//  LogYogaExerciseView.swift
import SwiftUI
import HealthKit

struct LogYogaExerciseView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    @EnvironmentObject var workoutDataViewModel: WorkoutDataViewModel
    @State private var durationInMinutes: Double = 30
    @State private var showingConfirmationAlert = false

    var body: some View {
        VStack {
            if let currentChallenge = poseViewModel.currentPoseOfTheDay {
                Text("Log Your Yoga Exercise for \(currentChallenge.englishName)")  // Display the current pose
                    .font(.headline)
                    .padding()

                // Show additional details about the pose
                Text("Sanskrit Name: \(currentChallenge.sanskritName)")
                    .padding(.bottom)

                // Duration Input
                HStack {
                    Text("Duration (minutes):")
                    Spacer()
                    TextField("Duration", value: $durationInMinutes, format: .number)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                }
                .padding()

                // Save Button
                Button("Save to Health App") {
                    saveYogaWorkout(pose: currentChallenge)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert("Workout Saved", isPresented: $showingConfirmationAlert) {
                    Button("OK", role: .cancel) {}
                }
            } else {
                Text("No pose of the day available.")
                    .font(.headline)
                    .padding()
            }
        }
        .padding()
    }

    private func saveYogaWorkout(pose: Pose) {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: Int(durationInMinutes), to: startDate)!

        workoutDataViewModel.saveYogaWorkout(startDate: startDate, endDate: endDate, activeEnergyBurned: nil, appleExerciseTime: durationInMinutes, oxygenSaturation: nil, respiratoryRate: nil)
        
        // Check if the workout was saved successfully
        if workoutDataViewModel.savedWorkouts.contains(where: { $0.startDate == startDate }) {
            showingConfirmationAlert = true
        }
    }
}

struct LogYogaExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        return LogYogaExerciseView()
            .environmentObject(PoseViewModel())
            .environmentObject(WorkoutDataViewModel())
    }
}


