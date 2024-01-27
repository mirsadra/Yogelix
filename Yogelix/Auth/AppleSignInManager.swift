//  AppleSignInManager.swift
import Foundation
import AuthenticationServices
import FirebaseAuth
import CryptoKit

protocol AppleSignInManagerDelegate: AnyObject {
    func didUpdateAuthenticationState(_ state: AuthenticationState)
    func didUpdateProfile(name: String, fullName: String, profilePicUrl: String)
    func didEncounterError(_ error: Error)
    func shouldSignOut()
    func deleteAppleUserAccount() async -> Bool
}

class AppleSignInManager {
    weak var delegate: AppleSignInManagerDelegate?
    private var currentNonce: String?
    
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            DispatchQueue.main.async {
                self.delegate?.didEncounterError(failure)
            }
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
                        let fullName = appleIDCredential.fullName?.formatted() ?? ""
                        let displayName = fullName.isEmpty ? (authResult.user.displayName ?? "") : fullName
                        let profilePicUrl = ""
                        
                        delegate?.didUpdateProfile(name: displayName, fullName: displayName, profilePicUrl: profilePicUrl)
                        delegate?.didUpdateAuthenticationState(.authenticated)
                    } catch {
                        delegate?.didEncounterError(error)
                    }
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
                            break
                        case .revoked, .notFound:
                            delegate?.shouldSignOut()
                        default:
                            break
                    }
                } catch {
                    
                }
            }
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
