//  WorkoutDataViewModel.swift
import Foundation
import HealthKit

class WorkoutDataViewModel: ObservableObject {
    private var workoutTypeManager = WorkoutTypeManager()

    // MARK: - Published properties to observe
    @Published var savedWorkouts: [HKWorkout] = []
    @Published var authorizationStatus: Bool = false
    @Published var error: WorkoutTypeManager.CustomError?

    init() {
        requestAuthorization()
    }

    // MARK: - Authorization
    private func requestAuthorization() {
        workoutTypeManager.requestAuthorization { [weak self] success, customError in
            DispatchQueue.main.async {
                self?.authorizationStatus = success
                if success {
                    self?.fetchYogaWorkouts() // Fetch workouts only after successful authorization
                } else {
                    self?.error = customError
                }
            }
        }
    }

    // MARK: - Saving Yoga Workout
    func saveYogaWorkout(startDate: Date, endDate: Date, activeEnergyBurned: Double?, appleExerciseTime: Double?, oxygenSaturation: Double?, respiratoryRate: Double?) {
        workoutTypeManager.saveYogaWorkout(startDate: startDate, endDate: endDate, activeEnergyBurned: activeEnergyBurned, appleExerciseTime: appleExerciseTime, oxygenSaturation: oxygenSaturation, respiratoryRate: respiratoryRate) { [weak self] workout, customError in
            DispatchQueue.main.async {
                if workout != nil {
                    self?.fetchYogaWorkouts() // Refresh the list of workouts
                } else {
                    self?.error = customError
                }
            }
        }
    }

    // MARK: - Reading Yoga Workouts
    func fetchYogaWorkouts() {
        workoutTypeManager.readYogaWorkouts { [weak self] workouts, customError in
            DispatchQueue.main.async {
                if let workouts = workouts {
                    self?.savedWorkouts = workouts
                } else {
                    self?.error = customError
                }
            }
        }
    }

    // Additional ViewModel methods for processing or formatting data can be added here
}
