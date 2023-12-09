//  LogYogaExerciseView.swift
import SwiftUI

struct LogYogaExerciseView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    @State private var durationInMinutes: Double = 30
    @State private var showingConfirmationAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let currentPose = poseViewModel.currentPoseOfTheDay {
                    Text("Log Your Yoga Exercise")
                        .font(.title)
                        .padding(.bottom, 5)

                    currentPose.image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()

                    Group {
                        Text("English Name: \(currentPose.englishName)")
                            .font(.headline)
                        Text("Sanskrit Name: \(currentPose.sanskritName)")
                            .font(.subheadline)
                        Text("Level: \(currentPose.level)")
                            .font(.subheadline)
                        Text("Difficulty: \(currentPose.difficulty)")
                            .font(.subheadline)
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
                    }
                    .padding(.horizontal)

                    // Save Button
                    Button(action: {
                        saveYogaWorkout(pose: currentPose)
                    }) {
                        Text("Save to Health App")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)

                    // Show confirmation alert
                    .alert("Workout Saved", isPresented: $showingConfirmationAlert) {
                        Button("OK", role: .cancel) {}
                    }
                } else {
                    Text("No pose of the day available.")
                        .font(.headline)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Yoga Pose Detail", displayMode: .inline)
    }

    private func saveYogaWorkout(pose: Pose) {
        // Logic to save the workout will remain the same
    }
}

struct LogYogaExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        LogYogaExerciseView()
            .environmentObject(PoseViewModel())
    }
}
