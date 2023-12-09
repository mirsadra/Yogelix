// PoseOfTheDay.swift
import SwiftUI

struct PoseOfTheDay: View {
    @EnvironmentObject var poseViewModel : PoseViewModel
    @EnvironmentObject var challengeManager: DailyChallengeManager
    
    var body: some View {
        ZStack {
            if let pose = challengeManager.currentChallenge {
                gradientBackground(for: pose.difficulty)
                    .frame(width: 360, height: 260)
                    .cornerRadius(20)
                    .overlay(
                        Text(Date(), formatter: dateFormatter)
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.6))
                            .padding(.bottom, 10),
                        alignment: .bottom
                    )
                
                VStack {
                    CircleImage(image: pose.image)
                        .offset(y: -130)
                        .padding(.bottom, -130)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(pose.englishName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            VStack {
                                NavigationLink(destination: PoseDetail(pose: pose).environmentObject(poseViewModel)) {
                                    Image(systemName: "info.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white)
                                }
                                
//                                NavigationLink(destination: LogYogaExerciseView()) {
//                                    Image(systemName: "flame.circle.fill")
//                                        .resizable()
//                                        .frame(width: 24, height: 24)
//                                        .foregroundColor(.red)
//                                }
                                
                                NavigationLink(destination: LogYogaExerciseView().environmentObject(poseViewModel)) {
                                    Image(systemName: "flame.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Text(pose.sanskritName)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.75))
                        
                        recommendedInfo(for: pose)
                        
                    }
                    .padding([.bottom, .horizontal])
                }
            }
        }
        
        .onAppear {
            challengeManager.loadChallenge()
        }
        .frame(width: 360, height: 260)
    }
    
    private func favoriteToggle(for pose: Pose) -> some View {
        Image(systemName: pose.isFavorite ? "heart.fill" : "heart")
            .foregroundColor(pose.isFavorite ? .red : .white)
            .onTapGesture {
                // Implement logic to toggle favorite status in poseViewModel
            }
    }
    
    private func recommendedInfo(for pose: Pose) -> some View {
        VStack {
            Text("Heart Rate: \(pose.recommendedFor.heartRate)")
            Text("Energy Burned: \(pose.recommendedFor.activeEnergyBurned)")
            Text("Exercise Minutes: \(pose.recommendedFor.exerciseMinutes)")
        }
        .foregroundColor(.white)
    }
    
    private func gradientBackground(for difficulty: Int) -> LinearGradient {
        let colors: [Color] = difficulty <= 2 ? [.green, .blue] : [.orange, .red]
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
