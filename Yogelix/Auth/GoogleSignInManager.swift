//  GoogleSignInManager.swift
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

protocol GoogleSignInManagerDelegate: AnyObject {
    func didUpdateAuthenticationState(_ state: AuthenticationState)
    func didUpdateProfile(name: String, fullName: String, profilePicUrl: String)
    func didEncounterError(_ error: Error)
    func shouldSignOut()
    func deleteGoogleUserAccount() async -> Bool
}

enum AuthenticationError: Error {
    case tokenError(message: String)
    // Add other Google Sign-In specific errors here if needed
}

class GoogleSignInManager {
    weak var delegate: GoogleSignInManagerDelegate?
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
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
            
            let result = try await Auth.auth().signIn(with: credential)
            
            let displayName = googleUser.profile?.name ?? ""
            let profilePicUrl = googleUser.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""
            
            delegate?.didUpdateProfile(name: displayName, fullName: displayName, profilePicUrl: profilePicUrl)
            delegate?.didUpdateAuthenticationState(.authenticated)
            
        } catch {
            delegate?.didEncounterError(error)
        }
        return false
    }
}
