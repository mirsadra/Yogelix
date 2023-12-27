//  AchievementsViewModel.swift
import Foundation
import FirebaseFirestore
import FirebaseAuth

class AchievementsViewModel: ObservableObject {
    @Published var user: User?
    @Published var userAchievements: [Achievement] = []
    
    // MARK: - Achievement
    func fetchAchievements() async {
        guard let userId = user?.uid else { return }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)
        
        do {
            let document = try await docRef.getDocument()
            if let data = document.data(), let achievementsData = data["achievements"] as? [[String: Any]] {
                processAchievementsData(achievementsData)
            } else {
                // No achievements data available, set default values
                DispatchQueue.main.async {
                    self.userAchievements = self.createDefaultAchievements()
                }
            }
        } catch {
            print("Error fetching achievements: \(error.localizedDescription)")
        }
    }
    
    private func createDefaultAchievements() -> [Achievement] {
        // Initialize default achievements with 0 trophies
        return [Achievement(id: "gold", count: 0),
                Achievement(id: "silver", count: 0),
                Achievement(id: "bronze", count: 0)]
    }
    
    // Intended to transform the raw dictionary data from Firestore into Swift "Achievement" data model.
    private func processAchievementsData(_ achievementsData: [[String: Any]]) {
        // Convert the array of dictionaries to an array of Achievement objects
        let achievements = achievementsData.compactMap { dict -> Achievement? in
            guard let id = dict["id"] as? String,
                  let count = dict["count"] as? Int else {
                return nil
            }
            
            return Achievement(id: id, count: count)
        }
        
        // Update the published userAchievements property
        DispatchQueue.main.async {
            self.userAchievements = achievements
        }
    }
    
}
