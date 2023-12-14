//  CreateWorkoutView.swift
import SwiftUI

struct CreateWorkoutView: View {
    @ObservedObject var viewModel = WorkoutDataViewModel()
    @State private var startDate = Date()
    @State private var difficultyLevel: Int = 1 // Difficulty level
    @State private var appleExerciseTime: Double = 5 // Default to 5 minutes, range 5-60 minutes
    @State private var estimatedCalories: Int = 0 // Estimated calories burned

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Details")) {
                    DatePicker("Start Time", selection: $startDate, displayedComponents: .hourAndMinute)

                    Picker("Difficulty Level", selection: $difficultyLevel) {
                        Text("Easy").tag(1)
                        Text("Medium").tag(2)
                        Text("Hard").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    VStack {
                        Text("Duration: \(Int(appleExerciseTime)) minutes")
                        Slider(value: $appleExerciseTime, in: 5...60, step: 1)
                            .onChange(of: appleExerciseTime) { _ in
                                calculateEstimatedCalories()
                            }
                    }

                    Text("Estimated Calories Burned: \(estimatedCalories)")
                }

                Button("Start Yoga Workout") {
                    startWorkout()
                }
                .disabled(!viewModel.authorizationStatus)
            }
            .navigationTitle("New Yoga Workout")
            .alert(item: $viewModel.error) { error in
                Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: calculateEstimatedCalories)
        }
    }

    private func startWorkout() {
        let endDate = Calendar.current.date(byAdding: .minute, value: Int(appleExerciseTime), to: startDate)!
        viewModel.saveYogaWorkout(startDate: startDate, endDate: endDate, activeEnergyBurned: Double(estimatedCalories), appleExerciseTime: appleExerciseTime)
    }

    private func calculateEstimatedCalories() {
        estimatedCalories = calculateCaloriesBurned(difficulty: difficultyLevel, duration: Int(appleExerciseTime))
    }

    private func calculateCaloriesBurned(difficulty: Int, duration: Int) -> Int {
        let baseCalorieBurnPerMinute: [Int: Int] = [1: 3, 2: 6, 3: 9]
        guard let caloriesPerMinute = baseCalorieBurnPerMinute[difficulty] else {
            print("Invalid difficulty level")
            return 0
        }

        if duration < 5 || duration > 60 {
            print("Invalid duration")
            return 0
        }

        return caloriesPerMinute * duration
    }
}

struct CreateWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        CreateWorkoutView()
    }
}

