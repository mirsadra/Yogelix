// AchievementView.swift
import SwiftUI

struct AchievementView: View {
    @EnvironmentObject var userData: UserData // Assumes UserData is provided as an EnvironmentObject

    var body: some View {
        ScrollView {
            VStack {
                Text("Achievements")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()

                // Dynamic display of trophies based on user's achievements
                ForEach(userData.achievements, id: \.id) { achievement in
                    VStack {
                        Text(achievement.poseName)
                            .font(.headline)
                            .padding(.top)

                        TrophyView(progress: achievement.progress,
                                   trophy: achievement.trophy,
                                   color: achievement.color)
                    }
                }
            }
        }
    }
}
