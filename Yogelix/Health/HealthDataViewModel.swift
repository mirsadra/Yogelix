//  HealthDataViewModel.swift
import Foundation
import HealthKit

class HealthDataViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    
    // MARK: - Published Properties
    @Published var bodyMassIndex: Double?
    @Published var heartRate: Double?
    @Published var activeEnergyBurn: Double?
    @Published var basalEnergyBurn: Double?
    @Published var oxygenSaturation: Double?
    @Published var heightCm: Double?
    @Published var walkingRunningDistance: [HKQuantitySample]?
    @Published var mindfulSessions: [HKCategorySample]?
    @Published var sleepAnalysis: [HKCategorySample]?
    @Published var exerciseMinutes: [HKQuantitySample]?
    @Published var standHours: [HKCategorySample]?
    @Published var biologicalSex: HKBiologicalSexObject?
    @Published var dateOfBirth: DateComponents?
    @Published var averageActiveEnergyBurn: Double?
    @Published var dailyAverageHeartRates: [(date: Date, averageHeartRate: Double)] = []
    @Published var heartRateReadings: [(Date, Double)]? = []
    @Published var activitySummary = HKActivitySummary()
    
    // MARK: - Initialization
    init() {
        requestAuthorization()
    }
    
    // MARK: - Private Methods
    private func requestAuthorization() {
        healthKitManager.requestAuthorization { [weak self] success, error in
            if success {
                self?.fetchActivitySummary()
            } else if let error = error {
                print("Authorization failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchData<T>(
            fetcher: (@escaping (T?, Error?) -> Void) -> Void,
            resultHandler: @escaping (T?) -> Void
        ) {
            fetcher { [weak self] result, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching data: \(error.localizedDescription)")
                        return
                    }
                    resultHandler(result)
                }
            }
        }
    
    // MARK: - Fetch Health Data Methods
    func fetchBodyMassIndex() {
        fetchData(fetcher: healthKitManager.readBodyMassIndex) { [weak self] bmiValue in
            self?.bodyMassIndex = bmiValue
            
        }
    }
    
    func fetchHeartRate() {
        fetchData(fetcher: healthKitManager.readHeartRate) { [weak self] samples in
            let latestHeartRate = samples?.first?.quantity.doubleValue(for: HKUnit(from: "count/min"))
            self?.heartRate = latestHeartRate
            if let samples = samples {
                self?.dailyAverageHeartRates = self?.processHeartRateSamples(samples) ?? []
            }
        }
    }
    
    func fetchHeight() {
        fetchData(fetcher: healthKitManager.readHeight) { [weak self] sample in
            let latestHeight = sample?.quantity.doubleValue(for: HKUnit.meterUnit(with: .centi))
            self?.heightCm = latestHeight
        }
    }
    
    func fetchActiveEnergyBurned() {
        fetchData(fetcher: healthKitManager.readActiveEnergyBurned) { [weak self] samples in
            let latestActiveEnergy = samples?.first?.quantity.doubleValue(for: HKUnit(from: "kcal"))
            self?.activeEnergyBurn = latestActiveEnergy
        }
    }

    func fetchBasalEnergyBurned() {
        fetchData(fetcher: healthKitManager.readBasalEnergyBurned) { [weak self] basalEnergy in
            self?.basalEnergyBurn = basalEnergy
        }
    }

    func fetchOxygenSaturation() {
        fetchData(fetcher: healthKitManager.readOxygenSaturation) { [weak self] saturation in
            self?.oxygenSaturation = saturation
        }
    }

    func fetchWalkingRunningDistance() {
        fetchData(fetcher: healthKitManager.readWalkingRunningDistance) { [weak self] samples in
            self?.walkingRunningDistance = samples
        }
    }

    func fetchMindfulSessions() {
        fetchData(fetcher: healthKitManager.readMindfulSessions) { [weak self] sessions in
            self?.mindfulSessions = sessions
        }
    }

    func fetchSleepAnalysis() {
        fetchData(fetcher: healthKitManager.readSleepAnalysis) { [weak self] samples in
            self?.sleepAnalysis = samples
        }
    }
    
    func fetchExerciseMinutes() {
        fetchData(fetcher: healthKitManager.readExerciseMinutes) { [weak self] samples in
            self?.exerciseMinutes = samples
        }
    }

    func fetchStandHours() {
        fetchData(fetcher: healthKitManager.readStandHours) { [weak self] samples in
            self?.standHours = samples
        }
    }

    func fetchBiologicalSex() {
        fetchData(fetcher: healthKitManager.readBiologicalSex) { [weak self] biologicalSex in
            self?.biologicalSex = biologicalSex
        }
    }

    func fetchDateOfBirth() {
        fetchData(fetcher: healthKitManager.readDateOfBirth) { [weak self] dateOfBirthComponents in
            self?.dateOfBirth = dateOfBirthComponents
        }
    }
    
    func fetchActivitySummary() {
        let group = DispatchGroup()
        
        group.enter()
        healthKitManager.readTotalActiveEnergyBurned { [weak self] totalCalories, _ in
            defer { group.leave() }
            if let totalCalories = totalCalories, let self = self {
                let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: totalCalories)
                self.activitySummary.activeEnergyBurned = quantity
                self.activitySummary.activeEnergyBurnedGoal = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: 500) // Set a goal or fetch from user preferences
            }
        }
        
        group.enter()
        healthKitManager.readTotalExerciseMinutes { [weak self] totalMinutes, _ in
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

    
    
    // MARK: - Daily Average for 7 days ( return seven numbers, each belongs to average of one day)
    

    // MARK: - Total average of 7 days ( return one number that is the average of 7 days)
    
    // MARK: - Summing up values (e.g. total active energy burned in a week)
    
    // MARK: - Trend Analysis
    
    
    // MARK: -
    
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
    
    func fetchAllData() {
        fetchBodyMassIndex()
        fetchActivitySummary()
        fetchHeartRate()
        fetchSleepAnalysis()
        fetchHeight()
        fetchActiveEnergyBurned()
        
    }
    
}



//    func fetchHeartRateChart() {
//        healthKitManager.readHeartRate { [weak self] samples, _ in
//            if let samples = samples {
//                let readings = samples.map { ($0.startDate, $0.quantity.doubleValue(for: HKUnit(from: "count/min"))) }
//                DispatchQueue.main.async {
//                    self?.heartRateReadings = readings
//                }
//            }
//        }
//    }
