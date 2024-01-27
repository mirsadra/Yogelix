// AuthenticationViewModel.swift
import Foundation
import FirebaseAuth
import SwiftUI
import AuthenticationServices

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
    
    private var appleSignInManager = AppleSignInManager()
    private var googleSignInManager = GoogleSignInManager()
    
    private var currentNonce: String?
    private lazy var userProfileViewModel: UserProfileViewModel = {
        return UserProfileViewModel()
    }()
    
    init() {
        registerAuthStateHandler()
        appleSignInManager.delegate = self
        googleSignInManager.delegate = self
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    // To make sure if the user has an account, the user will be redirected
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
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
            authenticationState = .unauthenticated // Update the authentication state
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
