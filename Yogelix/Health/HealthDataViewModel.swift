//  HealthDataViewModel.swift
import Foundation
import HealthKit

class HealthDataViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    
    @Published var activitySummary = HKActivitySummary()
    @Published var heartRate: Double? // Example for heart rate
    @Published var bodyMassIndex: Double?  // Example for body mass
    @Published var sleepAnalysis: [HKCategorySample]? // Example for sleep analysis
    @Published var heightCm: Double?
    @Published var dailyAverageHeartRates: [(date: Date, averageHeartRate: Double)] = []
    @Published var activeEnergy: Double?
    
    
    @Published var heartRateReadings: [(Date, Double)]? = []
    
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
    
    func loadBodyMass() {
        healthKitManager.readBodyMass { [weak self] sample, _ in
            let latestBodyMass = sample?.quantity.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                self?.bodyMassIndex = latestBodyMass
                return
            }
        }
    }
    
    func loadHeartRate() {
        healthKitManager.readHeartRate { [weak self] samples, _ in
            let latestHeartRate = samples?.first?.quantity.doubleValue(for: HKUnit(from: "count/min"))
            DispatchQueue.main.async {
                self?.heartRate = latestHeartRate
                // Now also calculate the daily averages when heart rates are loaded.
                if let samples = samples {
                    self?.dailyAverageHeartRates = self?.processHeartRateSamples(samples) ?? []
                    return
                }
            }
        }
    }
    
    func processHeartRateSamples(_ samples: [HKQuantitySample]) -> [(date: Date, averageHeartRate: Double)] {
        let groupedSamples = Dictionary(grouping: samples, by: { Calendar.current.startOfDay(for: $0.startDate) })
        let dailyAverages = groupedSamples.map { (date, samples) -> (Date, Double) in
            let total = samples.reduce(0) { $0 + $1.quantity.doubleValue(for: HKUnit(from: "count/min")) }
            let average = total / Double(samples.count)
            return (date, average)
        }
        // Sort by date and get the last 7 entries
        return Array(dailyAverages.sorted(by: { $0.0 < $1.0 }).suffix(7))
    }
    
    func loadHeartRateChart() {
        healthKitManager.readHeartRate { [weak self] samples, _ in
            if let samples = samples {
                let readings = samples.map { ($0.startDate, $0.quantity.doubleValue(for: HKUnit(from: "count/min"))) }
                DispatchQueue.main.async {
                    self?.heartRateReadings = readings
                }
            }
        }
    }
    
    func loadHeight() {
        healthKitManager.readHeight { [weak self] sample, _ in
            let latestHeight = sample?.quantity.doubleValue(for: HKUnit.meterUnit(with: .centi))
            DispatchQueue.main.async {
                self?.heightCm = latestHeight
                return
            }
        }
    }
    
    func loadSleepAnalysis() {
        healthKitManager.readSleepAnalysis { [weak self] samples, _ in
            DispatchQueue.main.async {
                self?.sleepAnalysis = samples
            }
        }
    }
    
    var moveRingProgress: CGFloat {
        let burned = activitySummary.activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
        let goal = activitySummary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
        return min(CGFloat(burned / goal), 1.0) // Progress should not exceed 1.0
    }
    
    // Computed property for exercise ring progress
    var exerciseRingProgress: CGFloat {
        let exerciseMinutes = activitySummary.appleExerciseTime.doubleValue(for: HKUnit.minute())
        let goalMinutes = activitySummary.appleExerciseTimeGoal.doubleValue(for: HKUnit.minute())
        return min(CGFloat(exerciseMinutes / goalMinutes), 1.0) // Progress should not exceed 1.0
    }
    
    // Computed property for stand ring progress
    var standRingProgress: CGFloat {
        // Assuming you have some logic to calculate stand hours progress
        let standHours = Double(activitySummary.appleStandHours.doubleValue(for: HKUnit.count()))
        let goalHours = Double(activitySummary.appleStandHoursGoal.doubleValue(for: HKUnit.count()))
        return min(CGFloat(standHours / goalHours), 1.0) // Progress should not exceed 1.0
    }
    
    func loadAllData() {
        loadActivitySummary()
        loadHeartRate()
        loadBodyMass()
        loadSleepAnalysis()
        loadHeight()
        loadHeartRateChart()
        
    }
    
}
