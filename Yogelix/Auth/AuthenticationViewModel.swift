//  AuthenticationViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import AuthenticationServices
import CryptoKit
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var user: User?
    @Published var errorMessage = ""
    @Published var displayName = ""
    
    private var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
        verifySignInWithAppleAuthenticationState()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    // To make sure if the user has an account, the user will be redirected
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    // New registerAuthStateListener
    func registerAuthStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if let user = user {
                // User is signed in
                self?.authenticationState = .authenticated
                self?.user = user
                self?.displayName = user.email ?? ""
            } else {
                // User is signed out
                self?.authenticationState = .unauthenticated
                self?.user = nil
                self?.displayName = ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    // MARK: - Upload Profile Picture
    enum ProfileImageError: Error {
        case failedToConvertImage
        case failedToUploadImage
        case failedToUpdateFirestore
        case unknownError
    }
    
    func uploadProfileImage(_ image: UIImage, for user: User) async -> Result<URL, Error> {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return .failure(ProfileImageError.failedToConvertImage)
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(user.uid).png")
        
        // Create metadata for the image
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"  // or "image/jpeg" if you're using JPEG
        
        do {
            // Upload the image data with metadata
            try await storageRef.putData(imageData, metadata: metadata)
            let imageUrl = try await storageRef.downloadURL()
            return .success(imageUrl)
        } catch {
            return .failure(ProfileImageError.unknownError)
        }
    }
    
    
    func updateProfileImageUrl(_ url: URL, for user: User) async -> Result<Void, Error> {
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user.uid)
        
        do {
            try await userDoc.setData(["profileImageUrl": url.absoluteString], merge: true)
            return .success(())
        } catch {
            return .failure(ProfileImageError.failedToUpdateFirestore)
        }
    }
    
    func fetchAndSetProfileImage() async {
        guard let uid = user?.uid else { return }
        
        let userDocRef = Firestore.firestore().collection("users").document(uid)
        do {
            let snapshot = try await userDocRef.getDocument()
            if let imageUrlString = snapshot.data()?["profileImageUrl"] as? String,
               let _ = URL(string: imageUrlString) {
                // Download the image data from the imageUrl and set it to your profileImage
                // Depending on your UI logic, you may need to publish changes to profileImage
            }
        } catch {
            // Handle errors, e.g., unable to fetch document, data format issues, etc.
        }
    }
}

// MARK: - Email and Password Authentication
extension AuthenticationViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            user = authResult.user
            print("User \(authResult.user.uid) signed in")
            return true
        } catch  {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            user = authResult.user
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated // Update the authentication state
            reset() // Reset user data
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}


// MARK: Sign in with Apple
extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}

extension AuthenticationViewModel {
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        }
        else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                // Performing actual sign in with apple
                Task {
                    do {
                        let result = try await Auth.auth().signIn(with: credential)
                        await updateDisplayName(for: result.user, with: appleIDCredential)  // to read user's full name from apple id token and assign it to firebase user.
                    }
                    catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user is non-empty, don't overwrite it
        }
        else {
            let changeRequest = user.createProfileChangeRequest()  // if the user's name was empty then we will create a profile change request and set the display name.
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()
                self.displayName = Auth.auth().currentUser?.displayName ?? ""
            }
            catch {
                print("Unable to update the user's displayname: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                    switch credentialState {
                        case .authorized:
                            break // The Apple ID credential is valid.
                        case .revoked, .notFound:
                            // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                            self.signOut()
                        default:
                            break
                    }
                }
                catch {
                    
                }
            }
        }
    }
    
}

// MARK: - Sign in with google
enum AuthenticationError: Error {
    case tokenError(message: String)
}

extension AuthenticationViewModel {
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            return false
        }

        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let googleUser = userAuthentication.user
            guard let idToken = googleUser.idToken else {
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            let accessToken = googleUser.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)

            // Retrieve the user's full name and profile picture URL
            let fullName = googleUser.profile?.name ?? ""
            let profilePicUrl = googleUser.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""

            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")

            // Store user's full name and profile picture URL in Firestore
            await storeUserData(uid: firebaseUser.uid, fullName: fullName, profilePicUrl: profilePicUrl)

            return true
        }
        catch {
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
            return false
        }
    }

    private func storeUserData(uid: String, fullName: String, profilePicUrl: String) async {
        let db = Firestore.firestore()
        do {
            try await db.collection("users").document(uid).setData([
                "fullName": fullName,
                "profilePicUrl": profilePicUrl
            ])
            print("User data stored successfully.")
        } catch {
            print("Error storing user data: \(error)")
        }
    }
}


// MARK: - Random Nonce String and Sha256
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
