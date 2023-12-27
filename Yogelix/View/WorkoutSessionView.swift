//  WorkoutSessionView.swift
import SwiftUI

struct WorkoutSessionView: View {
    let startDate: Date
    let endDate: Date
    @State private var currentTime = Date()
    @State private var workoutCompleted = false

    private var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.currentTime = Date()
            if self.currentTime >= self.endDate {
                self.workoutCompleted = true
                self.timer.invalidate()
            }
        }
    }

    private var timeRemaining: String {
        let remainingSeconds = Int(endDate.timeIntervalSince(currentTime))
        return remainingSeconds > 0 ? formatTime(seconds: remainingSeconds) : "00:00"
    }

    private var progress: Float {
        let totalDuration = endDate.timeIntervalSince(startDate)
        let elapsedTime = currentTime.timeIntervalSince(startDate)
        return Float(elapsedTime / totalDuration)
    }

    var body: some View {
        VStack {
            Text("Yoga Session")
                .font(.largeTitle)
                .padding()

            Text("Time Remaining: \(timeRemaining)")
                .font(.title)
                .padding()

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())

            if workoutCompleted {
                Text("Workout Completed!")
                    .font(.headline)
                    .foregroundColor(.green)
            }
        }
        .onAppear {
            _ = self.timer
        }
    }

    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct WorkoutSessionView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSessionView(startDate: Date(), endDate: Date().addingTimeInterval(1800))
    }
}
