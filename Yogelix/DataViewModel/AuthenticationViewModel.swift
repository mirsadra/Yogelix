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
import SwiftUI

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var user: User?
    @Published var errorMessage = ""
    @Published var displayName = ""
    @Published var fullName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var userAchievements: [Achievement] = []
    
    private var currentNonce: String?
    private lazy var userProfileViewModel: UserProfileViewModel = {
        return UserProfileViewModel()
    }()
    
    init() {
        registerAuthStateHandler()
        verifySignInWithAppleAuthenticationState()
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    // To make sure if the user has an account, the user will be redirected
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                self?.user = user
                if let user = user {
                    // User is authenticated
                    self?.authenticationState = .authenticated
                    self?.displayName = user.email ?? ""
                } else {
                    // User is not authenticated
                    self?.authenticationState = .unauthenticated
                }
            }
        }
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
    

}

// MARK: - Apple ID Credential Extension
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
            return
        }
        if case .success(let authorization) = result {
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
                
                Task {
                    do {
                        let authResult = try await Auth.auth().signIn(with: credential)
                        // Store the user's full name if it's provided and not yet stored.
                        if let fullName = appleIDCredential.fullName,
                           fullName.givenName != nil || fullName.familyName != nil {
                            let displayName = appleIDCredential.displayName()
                            await updateDisplayName(for: authResult.user, with: displayName)
                            await storeUserData(uid: authResult.user.uid, fullName: displayName, profilePicUrl: profilePicUrl)
                        } else {
                            // If full name is not available, fetch from Firestore.
                            await userProfileViewModel.fetchUserProfile()
                        }
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func updateDisplayName(for user: User, with displayName: String) async {
        // Only set the display name if it's not already set
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // current user already has a non-empty display name, don't overwrite it
        } else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            do {
                try await changeRequest.commitChanges()
                DispatchQueue.main.async {
                    self.displayName = displayName
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Unable to update the user's display name: \(error.localizedDescription)"
                }
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
            
            // Store user's full name and profile picture URL in Firestore
            await storeUserData(uid: firebaseUser.uid, fullName: fullName, profilePicUrl: profilePicUrl)
            
            return true
        } catch {
            switch error {
                case AuthenticationError.tokenError(message: _):
                    errorMessage = "🙈 Invalid token, try again!"
                default:
                    errorMessage = "🚨 An error occurred while signing in with Google. Please try again later."
            }
            print(error.localizedDescription)
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            authenticationState = .unauthenticated // Update the authentication state
            // Reset or clear any other relevant properties here
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Refactored User Data Storage
    private func storeUserData(uid: String, fullName: String, profilePicUrl: String) async {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(uid)

        // Default achievements to be added when creating the user profile
        let defaultAchievements = [
            ["id": "gold", "count": 0],
            ["id": "silver", "count": 0],
            ["id": "bronze", "count": 0]
        ]

        do {
            let docSnapshot = try await userDocRef.getDocument()

            if let docData = docSnapshot.data(), docData["fullName"] as? String != "" {
                // Full name already exists, no need to update it.
                print("Full name already stored in Firestore.")
            } else {
                // Full name doesn't exist or is empty, update it along with the profilePicUrl.
                try await userDocRef.setData([
                    "fullName": fullName,
                    "profilePicUrl": profilePicUrl,
                    "achievements": defaultAchievements // Include default achievements
                ], merge: true)
                print("User data stored successfully.")
            }
        } catch {
            print("Error accessing user data: \(error)")
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


public enum AuthError: Error {
    /// The email address is already in use by another account.
    case emailAlreadyInUse
    
    /// The user account is disabled from sign-in.
    case userDisabled
    
    /// The password is invalid.
    case wrongPassword
    
    /// The email address is invalid.
    case invalidEmail
    
    /// The an invalid email address was provided.
    case invalidCredential
    
    /// The operation is unable to complete due to a temporary problem.
    case operationNotAllowed
    
    /// The user denied the sign-in request.
    case userCancelled
    
    /// The user id supplied is invalid.
    case invalidUser
    
}
