//  Achievement.swift
import SwiftUI

struct AchievementView: View {
    @State private var exerciseProgress: Double = 0.6
    @State private var yogaProgress: Double = 0.8
    
    var body: some View {
        VStack {
            Text("Achievements")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .padding()
            
            HStack {
                VStack{
                    Image(systemName: "trophy.circle.fill")
                        .font(Font.custom("SF Pro", size: 24))
                        .foregroundStyle(.gray)
                    Text("1")
                }
                
                VStack {
                    Image(systemName: "trophy.circle.fill")
                        .font(Font.custom("SF Pro", size: 32))
                        .foregroundStyle(.yellow)
                    Text("0")
                }
                VStack {
                    Image(systemName: "trophy.circle.fill")
                        .font(Font.custom("SF Pro", size: 20))
                        .foregroundStyle(.orange)
                    Text("1")
                }
            }
            
            Spacer()
            
            HStack {
                TrophyView(progress: exerciseProgress, activityName: "Exercise", color: .green)
                TrophyView(progress: yogaProgress, activityName: "Yoga", color: .purple)
            }
        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView()
    }
}
