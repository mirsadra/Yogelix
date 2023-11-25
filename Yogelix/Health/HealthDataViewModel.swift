//  HealthDataViewModel.swift
import Foundation
import HealthKit

class HealthDataViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    @Published var activitySummary = HKActivitySummary()
    
    init() {
            requestAuthorization()
        }
    
    func requestAuthorization() {
            healthKitManager.requestAuthorization { [weak self] success, error in
                if success {
                    self?.loadActivitySummary()
                } else if let error = error {
                    print("Authorization failed with error: \(error.localizedDescription)")
                }
            }
        }
    
    func loadActivitySummary() {
        let group = DispatchGroup()
        
        group.enter()
        healthKitManager.fetchTotalActiveEnergyBurned { [weak self] totalCalories, _ in
            defer { group.leave() }
            if let totalCalories = totalCalories, let self = self {
                let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: totalCalories)
                self.activitySummary.activeEnergyBurned = quantity
                self.activitySummary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 500) // Set a goal or fetch from user preferences
            }
        }
        
        group.enter()
        healthKitManager.fetchTotalExerciseMinutes { [weak self] totalMinutes, _ in
            defer { group.leave() }
            if let totalMinutes = totalMinutes, let self = self {
                let quantity = HKQuantity(unit: HKUnit.minute(), doubleValue: totalMinutes)
                self.activitySummary.appleExerciseTime = quantity
                self.activitySummary.appleExerciseTimeGoal = HKQuantity(unit: HKUnit.minute(), doubleValue: 30) // Set a goal or fetch from user preferences
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            // Update the UI here if needed
            self?.objectWillChange.send()
        }
    }

}
