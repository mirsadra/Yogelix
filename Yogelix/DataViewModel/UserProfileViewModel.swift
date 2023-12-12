//  UserProfileViewModel.swift
import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var exerciseDuration: TimeInterval = 0
    @Published var achievements: [String] = []

    private var db = Firestore.firestore()

    init() {
        loadUserProfile()
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
