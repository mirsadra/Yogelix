//  YogaWorkoutView.swift
import SwiftUI

struct YogaTimerView: View {
    var pose: Pose  // Assuming 'Pose' is your model class
    var durationInMinutes: Double
    @Environment(\.presentationMode) var presentationMode
    @State private var timeRemaining: Int
    @State private var timer: Timer?

    init(pose: Pose, durationInMinutes: Double) {
        self.pose = pose
        self.durationInMinutes = durationInMinutes
        self._timeRemaining = State(initialValue: Int(durationInMinutes * 60)) // Convert minutes to seconds
    }

    var body: some View {
        VStack {
            Text(pose.englishName) // Display pose information
            // ... (additional pose details)
            Text("Time Remaining: \(timeRemaining) seconds")
            Button(timer == nil ? "Start" : "Stop") {
                if timer == nil {
                    startTimer()
                } else {
                    stopTimer()
                }
            }
        }
        .onDisappear {
            self.timer?.invalidate()
        }
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                saveWorkout()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func saveWorkout() {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-durationInMinutes * 60)
        // Add logic to save the workout using your existing saveYogaWorkout function
    }
}
