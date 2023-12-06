// UserData.swift
import SwiftUI
import FirebaseFirestore

class UserData: ObservableObject {
    @Published var achievements: [Achievement] = []
    private var db = Firestore.firestore()
    private var userId: String
    
    // Initialize with user id to fetch data specific to the logged-in user
    init(userId: String) {
        self.userId = userId
        loadUserData()
    }
    
    private func loadUserData() {
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.getDocument { [weak self] document, error in
            if let document = document, document.exists {
                let data = document.data()
                // Parse achievements data from Firestore and update achievements
                self?.parseAchievementsData(data: data)
            } else {
                print("Document does not exist \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    private func parseAchievementsData(data: [String: Any]?) {
        // Assuming 'achievements' is an array of dictionaries
        if let achievementsData = data?["achievements"] as? [[String: Any]] {
            self.achievements = achievementsData.compactMap { dict in
                guard let name = dict["name"] as? String,
                      let poseName = dict["poseName"] as? String,
                      let progress = dict["progress"] as? Double,
                      let trophyRawValue = dict["trophy"] as? String,
                      let trophy = TrophyType(rawValue: trophyRawValue),
                      let colorString = dict["color"] as? String,
                      let color = Color(hex: colorString) else {
                    return nil
                }
                return Achievement(id: UUID(), name: name, poseName: poseName, progress: progress, trophy: trophy, color: color)
            }
        }
    }

    //
    func updateAchievement(for pose: Pose, with trophy: TrophyType) {
        // Create a new achievement entry
        let newAchievement = [
            "poseName": pose.englishName,
            "trophy": trophy.rawValue, // Corrected after defining TrophyType as enum
            "date": Date() // Storing the date when the achievement was earned
        ] as [String : Any]

        // Update the user's achievements in Firestore
        let userDocRef = db.collection("users").document(userId)
        userDocRef.updateData(["achievements": FieldValue.arrayUnion([newAchievement])]) { error in
            if let error = error {
                print("Error updating achievements: \(error.localizedDescription)")
            } else {
                // Update the local achievements array
                // Assuming you have a way to convert newAchievement dict to Achievement object
                // Add the new achievement to the local achievements array
                if let newAchievementObject = convertDictToAchievement(newAchievement) {
                    self.achievements.append(newAchievementObject)
                }
            }
        }
    }
}

// Helper function to convert a dictionary to Achievement object
private func convertDictToAchievement(_ dict: [String: Any]) -> Achievement? {
    guard let name = dict["name"] as? String,
          let poseName = dict["poseName"] as? String,
          let progress = dict["progress"] as? Double,
          let trophyRawValue = dict["trophy"] as? String,
          let trophy = TrophyType(rawValue: trophyRawValue),
          let colorHex = dict["color"] as? String,
          let color = Color(hex: colorHex) else {
        return nil
    }

    return Achievement(id: UUID(), name: name, poseName: poseName, progress: progress, trophy: trophy, color: color)
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
    
    func toHexString() -> String {
        // Convert Color to UIColor
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // Convert components to hex string
        let redHex = String(format: "%02X", Int(red * 255))
        let greenHex = String(format: "%02X", Int(green * 255))
        let blueHex = String(format: "%02X", Int(blue * 255))
        let alphaHex = String(format: "%02X", Int(alpha * 255))
        
        return "#\(redHex)\(greenHex)\(blueHex)\(alphaHex)"
    }
}
