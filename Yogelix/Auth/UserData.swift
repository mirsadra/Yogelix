// UserData.swift
import SwiftUI
import FirebaseFirestore

class UserData: ObservableObject {
    @Published var achievements: [Achievement] = []
    private var db = Firestore.firestore()

    // Initialize with user id to fetch data specific to the logged-in user
    init(userId: String) {
        loadUserData(userId: userId)
    }

    private func loadUserData(userId: String) {
        let userDocRef = db.collection("users").document(userId)

        userDocRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                // Parse achievements data from Firestore and update achievements
                self.parseAchievementsData(data: data)
            } else {
                print("Document does not exist \(error?.localizedDescription ?? "")")
            }
        }
    }

    private func parseAchievementsData(data: [String: Any]?) {
        // Assuming data contains an array of achievements with fields 'name', 'progress', and 'color'
        if let achievementsData = data?["achievements"] as? [[String: Any]] {
            for achievementData in achievementsData {
                if let name = achievementData["name"] as? String,
                   let progress = achievementData["progress"] as? Double,
                   let colorString = achievementData["color"] as? String,
                   let color = Color(hex: colorString) { // Convert hex string to Color
                    let achievement = Achievement(name: name, progress: progress, color: color)
                    self.achievements.append(achievement)
                }
            }
        }
    }

    // Add methods to update achievements and store them in Firestore
}

// Helper extension to convert hex color string to SwiftUI Color
extension Color {
    init?(hex: String) {
        let r, g, b, a: Double

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = Double((hexNumber & 0xff000000) >> 24) / 255
                    g = Double((hexNumber & 0x00ff0000) >> 16) / 255
                    b = Double((hexNumber & 0x0000ff00) >> 8) / 255
                    a = Double(hexNumber & 0x000000ff) / 255

                    self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
                    return
                }
            }
        }
        return nil
    }
}
