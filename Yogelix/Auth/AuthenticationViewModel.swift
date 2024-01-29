// AuthenticationViewModel.swift
import Foundation
import FirebaseAuth
import SwiftUI
import AuthenticationServices
import FirebaseFirestore
import FirebaseStorage

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case logout
}


class AuthenticationViewModel: ObservableObject, AppleSignInManagerDelegate, GoogleSignInManagerDelegate {
    @Published var email = ""
    @Published var flow: AuthenticationFlow = .login
    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: User?
    @Published var displayName = ""
    @Published var fullName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var exerciseDuration: TimeInterval = 0
    @Published var achievements: [String] = []
    
    private var appleSignInManager = AppleSignInManager()
    private var googleSignInManager = GoogleSignInManager()
    private var db = Firestore.firestore()
    
    private var currentNonce: String?
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        registerAuthStateHandler()
        appleSignInManager.delegate = self
        googleSignInManager.delegate = self
        loadPersistedData()
        loadUserProfile()
    }
    
    // MARK: - Persistence
    private func savePersistedData() {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "userEmail")
        defaults.set(displayName, forKey: "userDisplayName")
        defaults.set(fullName, forKey: "userFullName")
        defaults.set(profilePicUrl, forKey: "userProfilePicUrl")
        defaults.set(exerciseDuration, forKey: "userExerciseDuration")
        defaults.set(achievements, forKey: "userAchievements")
    }

    private func loadPersistedData() {
        let defaults = UserDefaults.standard
        email = defaults.string(forKey: "userEmail") ?? ""
        displayName = defaults.string(forKey: "userDisplayName") ?? ""
        fullName = defaults.string(forKey: "userFullName") ?? ""
        profilePicUrl = defaults.string(forKey: "userProfilePicUrl") ?? ""
        exerciseDuration = defaults.double(forKey: "userExerciseDuration")
        achievements = defaults.object(forKey: "userAchievements") as? [String] ?? []
    }
    
    // MARK: - User Profile Management
    func loadUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)

        Task {
            do {
                let document = try await docRef.getDocument()
                if document.exists {
                    let data = document.data()
                    DispatchQueue.main.async {
                        self.updateLocalUserData(with: data)
                    }
                } else {
                    print("Document does not exist")
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error fetching user profile data: \(error)"
                }
            }
        }
    }
    
    private func updateLocalUserData(with data: [String: Any]?) {
        if let duration = data?["exerciseDuration"] as? TimeInterval {
            self.exerciseDuration = duration
        }
        if let achievements = data?["achievements"] as? [String] {
            self.achievements = achievements
        }
        self.fullName = data?["fullName"] as? String ?? ""
        self.profilePicUrl = data?["profilePicUrl"] as? String ?? ""
    }
    
    // MARK: - Profile Image (Upload and Remove)
    func uploadProfileImage(_ imageData: Data) async {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "User must be logged in to upload an image."
            return
        }
        let storageRef = Storage.storage().reference().child("profile_pictures").child("\(uid).jpg")
        do {
            // Upload the image to Firebase Storage
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            
            // Once the image is uploaded, retrieve the download URL
            let downloadURL = try await storageRef.downloadURL()
            self.profilePicUrl = downloadURL.absoluteString
            
            // Update the user's profile in Firestore to include the new image URL
            let db = Firestore.firestore()
            try await db.collection("users").document(uid).setData(["profilePicUrl": profilePicUrl], merge: true)
            
        } catch {
            // Handle any errors
            print(error.localizedDescription)
            errorMessage = "There was an error uploading the image: \(error.localizedDescription)"
        }
    }
    
    func removeProfileImage() {
        guard let uid = Auth.auth().currentUser?.uid else {
            errorMessage = "User must be logged in to remove an image."
            return
        }
        
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference().child("profile_pictures").child("\(uid).jpg")
        
        Task {
            do {
                // Delete the image from Firebase Storage
                try await storageRef.delete()
                
                // Remove the image URL from Firestore
                try await db.collection("users").document(uid).updateData(["profilePicUrl": FieldValue.delete()])
                
                // Update the local profilePicUrl property
                DispatchQueue.main.async {
                    self.profilePicUrl = ""
                }
            } catch {
                // Handle any errors
                DispatchQueue.main.async {
                    self.errorMessage = "There was an error removing the image: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func updateExerciseDuration(duration: TimeInterval) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)
        
        Task {
            do {
                try await docRef.updateData(["exerciseDuration": duration])
                DispatchQueue.main.async {
                    self.exerciseDuration = duration
                }
            } catch {
                print("Error updating exercise duration: \(error)")
            }
        }
    }
    
    
    // MARK: - Sign In with Apple & Google
    func signInWithApple(request: ASAuthorizationAppleIDRequest) {
        appleSignInManager.handleSignInWithAppleRequest(request)
    }
    
    func handleAppleSignInCompletion(result: Result<ASAuthorization, Error>) {
        appleSignInManager.handleSignInWithAppleCompletion(result)
    }
    
    func signInWithGoogle() async {
        await googleSignInManager.signInWithGoogle()
    }
    
    func deleteAppleUserAccount() async -> Bool {
        return await deleteAccount()
    }

    func deleteGoogleUserAccount() async -> Bool {
        return await deleteAccount()
    }
    
    func didUpdateProfile(name: String, fullName: String, profilePicUrl: String) {
        DispatchQueue.main.async {
            self.displayName = name
            self.fullName = fullName
            self.profilePicUrl = profilePicUrl
            self.savePersistedData()
        }
    }
    
    func didCompleteFirebaseSignIn(result: AuthDataResult) {
        DispatchQueue.main.async {
            self.user = result.user
            self.email = result.user.email ?? ""
            self.displayName = result.user.displayName ?? ""
            self.savePersistedData()
        }
    }
    
    func didUpdateAuthenticationState(_ state: AuthenticationState) {
        DispatchQueue.main.async {
            self.authenticationState = state
            
        }
    }
    
    func didEncounterError(_ error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func shouldSignOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.authenticationState = .unauthenticated // Update the authentication state
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
            return false
        }
    }
    
    // To make sure if the user has an account, the user will be redirected
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
                DispatchQueue.main.async {
                    self?.user = user
                    if let user = user {
                        self?.authenticationState = .authenticated
                        self?.email = user.email ?? ""
                    } else {
                        self?.authenticationState = .unauthenticated
                    }
                }
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .logout : .login
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
}
