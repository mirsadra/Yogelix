// LogYogaExerciseView.swift
import SwiftUI

struct LogYogaExerciseView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    @State private var durationInMinutes: Double = 30
    @State private var dailyExercise: DailyExercise?
    @State private var achievement: Achievement?
    @State private var showingConfirmationAlert = false

    func calculateActiveEnergyBurned(durationInMinutes: Double, userWeightKg: Double) -> Double {
        let metValue = 3.0 // Average for yoga; adjust based on intensity
        let hours = durationInMinutes / 60.0
        return metValue * userWeightKg * hours // Returns kcal burned
    }

    func startExercise() {
        if let currentPose = poseViewModel.currentPoseOfTheDay {
            let exercise = DailyExercise(pose: currentPose, durationInMinutes: Int(durationInMinutes), date: Date(), isCompleted: false)
            self.dailyExercise = exercise

            // Example Achievement Creation
            let exerciseAchievement = Achievement(name: "Yoga Champion", poseName: currentPose.englishName, progress: 0.0, trophy: .gold, color: .yellow, relatedExercise: exercise)
            self.achievement = exerciseAchievement
            // Continue with starting exercise...
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let currentPose = poseViewModel.currentPoseOfTheDay {
                        exerciseDetails(for: currentPose)

                        // Navigation Link to AchievementView
                        NavigationLink(destination: AchievementView()) {
                            Text("View Achievements")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        noPoseAvailableView()
                    }
                }
            }
            .navigationBarTitle("Yoga Pose Detail", displayMode: .inline)
        }
    }

    @ViewBuilder
    private func exerciseDetails(for pose: Pose) -> some View {
        VStack {
            Text("Ready for Daily Quest? 🦸🏼‍♂️🦸🏾‍♀️")
                .font(.title)

            CircleImage(image: pose.image)
                .scaledToFit()
                .frame(height: 200)
                .padding()
            
            Group {
                Text("\(pose.englishName)")
                    .font(.headline)
                Text("\(pose.sanskritName)")
                    .font(.subheadline)
                LevelIndicator(level: pose.level)
            }
            .padding(.horizontal)
            
            // Duration Input
            HStack {
                Text("Duration (minutes):")
                    .font(.subheadline)
                Spacer()
                TextField("Duration", value: $durationInMinutes, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .multilineTextAlignment(.trailing)

                Button("Start Exercise") {
                    startExercise()
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    @ViewBuilder
    private func noPoseAvailableView() -> some View {
        Text("No pose of the day available.")
            .font(.headline)
            .padding()
        Button("Start Exercise") {
            // Placeholder for action when no pose is available
        }
    }
}

struct LogYogaExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        LogYogaExerciseView()
            .environmentObject(PoseViewModel())
    }
}
