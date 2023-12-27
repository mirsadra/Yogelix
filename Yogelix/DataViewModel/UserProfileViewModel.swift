//  UserProfileViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var profilePicColor: Color = .primary
    
    @Published var errorMessage = ""
    
    @Published var exerciseDuration: TimeInterval = 0
    @Published var achievements: [String] = []
    

    private var db = Firestore.firestore()

    init() {
        loadUserProfile()
    }
    
    // MARK: - User Profile
    func fetchUserProfile() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let data = document.data()
                let fetchedFullName = data?["fullName"] as? String ?? ""
                let fetchedProfilePicUrl = data?["profilePicUrl"] as? String ?? ""
                DispatchQueue.main.async {
                    self.fullName = fetchedFullName
                    self.profilePicUrl = fetchedProfilePicUrl
                }
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    
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
    

    // Load the user's profile data from Firestore
    func loadUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)
        
        Task {
            do {
                let document = try await docRef.getDocument()
                if document.exists {
                    let data = document.data()
                    updateLocalUserData(with: data)
                } else {
                    print("Document does not exist")
                }
            } catch {
                print("Error fetching user profile data: \(error)")
            }
        }
    }

    // Update local user data with Firestore data
    private func updateLocalUserData(with data: [String: Any]?) {
        DispatchQueue.main.async {
            if let duration = data?["exerciseDuration"] as? TimeInterval {
                self.exerciseDuration = duration
            }
            if let achievements = data?["achievements"] as? [String] {
                self.achievements = achievements
            }
        }
    }

    // Update the user's exercise duration in Firestore and locally
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

    // Add a new achievement to the user's profile in Firestore and locally
    func addAchievement(achievement: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)
        
        Task {
            do {
                try await docRef.updateData(["achievements": FieldValue.arrayUnion([achievement])])
                DispatchQueue.main.async {
                    self.achievements.append(achievement)
                }
            } catch {
                print("Error adding achievement: \(error)")
            }
        }
    }
    
    
}
