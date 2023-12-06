//  LogYogaExerciseView.swift
import SwiftUI
import HealthKit

struct LogYogaExerciseView: View {
    // Replace this with your actual yoga poses
    private let yogaPoses = ["Pose 1", "Pose 2", "Pose 3"]
    @State private var selectedPose = "Pose 1"
    @State private var durationInMinutes: Double = 30
    @State private var showingConfirmationAlert = false

    // Use WorkoutDataViewModel
    @StateObject private var workoutDataViewModel = WorkoutDataViewModel()

    var body: some View {
        VStack {
            Text("Log Your Yoga Exercise")
                .font(.headline)
                .padding()

            // Yoga Pose Picker
            Picker("Select Yoga Pose", selection: $selectedPose) {
                ForEach(yogaPoses, id: \.self) {
                    Text($0)
                }
            }
            .padding()

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
                saveYogaWorkout()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .alert("Workout Saved", isPresented: $showingConfirmationAlert) {
                Button("OK", role: .cancel) {}
            }
        }
        .padding()
    }

    private func saveYogaWorkout() {
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
        LogYogaExerciseView()
    }
}
