//  UserService.swift
import FirebaseFirestore
import FirebaseAuth

class UserService {
    
    func fetchUserProfile(uid: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                completion(.failure(UserServiceError.noData))
                return
            }
            
            let userProfile = UserProfile(data: data)
            completion(.success(userProfile))
        }
    }
    
    func updateUserProfile(uid: String, profile: UserProfile, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(profile.toDictionary(), merge: true) { error in
            completion(error)
        }
    }

    // ... Additional user service methods as required ...
}

enum UserServiceError: Error {
    case noData
}

struct UserProfile {
    var fullName: String
    var profilePicUrl: String
    
    // Initialize from a Firestore document data
    init(data: [String: Any]) {
        self.fullName = data["fullName"] as? String ?? ""
        self.profilePicUrl = data["profilePicUrl"] as? String ?? ""
    }
    
    // Convert to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return ["fullName": fullName, "profilePicUrl": profilePicUrl]
    }
}
