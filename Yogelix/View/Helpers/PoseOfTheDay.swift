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
                    HStack {
                        NavigationLink(destination: PoseDetail(pose: pose).environmentObject(poseViewModel)) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        CircleImage(image: pose.image)
                            .offset(y: -40)
                        
                        NavigationLink(destination: LogYogaExerciseView().environmentObject(poseViewModel)) {
                            Image(systemName: "flame")
                                .resizable()
                                .frame(width: 20, height: 24)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    
                    Text(pose.englishName)
                        .font(.headline)
                        .foregroundColor(.white)

                    recommendedInfo(for: pose)
                        .padding(.bottom, 80)
                    
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
            Text("Heart Rate: \(pose.recommendedFor.heartRate.rawValue)")
            Text("Energy Burned: \(pose.recommendedFor.activeEnergyBurned.rawValue)")
            Text("Exercise Minutes: \(pose.recommendedFor.exerciseMinutes.rawValue)")
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


extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = CGSize(width: 360, height: 260)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
