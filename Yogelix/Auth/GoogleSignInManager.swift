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
    func didCompleteFirebaseSignIn(result: AuthDataResult)
    func deleteGoogleUserAccount() async -> Bool
}

enum AuthenticationError: Error {
    case tokenError(message: String)
    // Add other Google Sign-In specific errors here if needed
}

class GoogleSignInManager {
    weak var delegate: GoogleSignInManagerDelegate?

    func signInWithGoogle() async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                guard let clientID = FirebaseApp.app()?.options.clientID else {
                    fatalError("No client ID found in Firebase configuration")
                }
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first,
                      let rootViewController = window.rootViewController else {
                    print("There is no root view controller")
                    continuation.resume(returning: false)
                    return
                }
                
                GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] user, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self.delegate?.didEncounterError(error)
                        }
                        continuation.resume(returning: false)
                        return
                    }
                    
                    guard let user = user, let idToken = user.user.idToken else {
                        continuation.resume(returning: false)
                        return
                    }
                    let accessToken = user.user.accessToken
                    let credential = GoogleAuthProvider.credential(withIDToken: "idToken", accessToken: "accessToken")
                    
                    Task {
                        do {
                            let result = try await Auth.auth().signIn(with: credential)
                            DispatchQueue.main.async {
                                self.delegate?.didCompleteFirebaseSignIn(result: result)
                                self.delegate?.didUpdateProfile(name: user.user.profile?.givenName ?? "", fullName: user.user.profile?.name ?? "", profilePicUrl: user.user.profile?.imageURL(withDimension: 200)?.absoluteString ?? "")
                                self.delegate?.didUpdateAuthenticationState(.authenticated)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.delegate?.didEncounterError(error)
                            }
                        }
                        
                        continuation.resume(returning: true)
                    }
                }
            }
        }
    }
}
