//  Achievement.swift
import SwiftUI

struct AchievementView: View {
    @EnvironmentObject var userData: UserData // Assumes UserData is provided as an EnvironmentObject

    var body: some View {
        VStack {
            Text("Achievements")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()

            // Dynamic display of trophies based on user's achievements
            HStack {
                ForEach(userData.achievements, id: \.name) { achievement in
                    TrophyView(progress: achievement.progress,
                               activityName: achievement.name,
                               color: achievement.color)
                }
            }
        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView().environmentObject(UserData(userId: "testUserID")) // Example usage
    }
}

