//  HealthDataViewModel.swift
import Foundation
import HealthKit

class HealthDataViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    
    // MARK: - Published Properties
    @Published var bodyMassIndexReadings: [(Date, Double)]?
    @Published var heartRateReadings: [(Date, Double)]?
    @Published var heightReading: Double?
    @Published var walkingRunningDistanceReadings: [(Date, Double)]?
    @Published var activeEnergyBurnReadings: [(Date, Double)]?
    @Published var oxygenSaturationReadings: [(Date, Double)]?
    @Published var basalEnergyBurnReadings: [(Date, Double)]?
    @Published var exerciseMinutesReadings: [(Date, Double)]?
    @Published var standHoursReadings: [HKCategorySample]?
    @Published var mindfulSessionsReadings: [HKCategorySample]?
    @Published var biologicalSex: HKBiologicalSexObject?
    @Published var dateOfBirth: DateComponents?
    @Published var sleepAnalysis: [HKCategorySample]?
    @Published var activitySummary = HKActivitySummary()
    
    // MARK: - Initialization
    init() {
        requestAuthorization()
        fetchAllData()
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
    func fetchBodyMassIndexReadings() {
        fetchData(fetcher: healthKitManager.readBodyMassIndex) { [weak self] readings in
            self?.bodyMassIndexReadings = readings
        }
    }
    
    func fetchHeartRateReadings() {
        fetchData(fetcher: healthKitManager.readHeartRate) { [weak self] readings in
            self?.heartRateReadings = readings
        }
    }
    
    func fetchHeight() {
        fetchData(fetcher: healthKitManager.readHeight) { [weak self] sample in
            let latestHeight = sample?.quantity.doubleValue(for: HKUnit.meterUnit(with: .centi))
            self?.heightReading = latestHeight
        }
    }
    
    func fetchActiveEnergyBurnReading() {
        fetchData(fetcher: healthKitManager.readActiveEnergyBurned) { [weak self] readings in
            self?.activeEnergyBurnReadings = readings
        }
    }
    
    func fetchBasalEnergyBurnReading() {
        fetchData(fetcher: healthKitManager.readBasalEnergyBurned) { [weak self] basalEnergy in
            self?.basalEnergyBurnReadings = basalEnergy
        }
    }
    
    func fetchOxygenSaturationReadings() {
        fetchData(fetcher: healthKitManager.readOxygenSaturation) { [weak self] saturation in
            self?.oxygenSaturationReadings = saturation
        }
    }
    
    func fetchWalkingRunningDistanceReadings() {
        fetchData(fetcher: healthKitManager.readWalkingRunningDistance) { [weak self] samples in
            self?.walkingRunningDistanceReadings = samples
        }
    }
    
    func fetchMindfulSessionsReadings() {
        fetchData(fetcher: healthKitManager.readMindfulSessions) { [weak self] sessions in
            self?.mindfulSessionsReadings = sessions
        }
    }
    
    func fetchSleepAnalysis() {
        fetchData(fetcher: healthKitManager.readSleepAnalysis) { [weak self] samples in
            self?.sleepAnalysis = samples
        }
    }
    
    func fetchExerciseMinutesReadings() {
        fetchData(fetcher: healthKitManager.readExerciseMinutes) { [weak self] samples in
            self?.exerciseMinutesReadings = samples
        }
    }
    
    func fetchStandHoursReadings() {
        fetchData(fetcher: healthKitManager.readStandHours) { [weak self] samples in
            self?.standHoursReadings = samples
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
    
    var moveRingProgress: CGFloat {
        let burned = activitySummary.activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
        let goal = activitySummary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
        return min(CGFloat(burned / goal), 1.0) // Progress should not exceed 1.0
    }
    
    // Computed property for exercise ring progress
    var exerciseRingProgress: CGFloat {
        let exerciseMinutesReadings = activitySummary.appleExerciseTime.doubleValue(for: HKUnit.minute())
        let goalMinutes = activitySummary.appleExerciseTimeGoal.doubleValue(for: HKUnit.minute())
        return min(CGFloat(exerciseMinutesReadings / goalMinutes), 1.0) // Progress should not exceed 1.0
    }
    
    // Computed property for stand ring progress
    var standRingProgress: CGFloat {
        // Assuming you have some logic to calculate stand hours progress
        let standHoursReadings = Double(activitySummary.appleStandHours.doubleValue(for: HKUnit.count()))
        let goalHours = Double(activitySummary.appleStandHoursGoal.doubleValue(for: HKUnit.count()))
        return min(CGFloat(standHoursReadings / goalHours), 1.0) // Progress should not exceed 1.0
    }
    
    // MARK: - Fetch All Data
    func fetchAllData() {
        fetchBodyMassIndexReadings()
        fetchActivitySummary()
        fetchHeartRateReadings()
        fetchSleepAnalysis()
        fetchHeight()
        fetchActiveEnergyBurnReading()
        fetchWalkingRunningDistanceReadings()

    }
    
    // MARK: - Calculation & Date & Date Interval
        // MARK: - Total (Sum) of Day, Week, and Month
    func getDailyTotal(readings: [(Date, Double)]) -> (total: Double, date: Date) {
        let today = Calendar.current.startOfDay(for: Date())
        let total = readings
            .filter { Calendar.current.isDate($0.0, inSameDayAs: today) }
            .map { $0.1 }
            .reduce(0, +)
        return (total, today)
    }

    func getWeeklyTotal(readings: [(Date, Double)]) -> (total: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: mostRecentDate)!
        let total = readings
            .filter { $0.0 >= startDate && $0.0 <= mostRecentDate }
            .map { $0.1 }
            .reduce(0, +)
        return (total, startDate, mostRecentDate)
    }

    func getMonthlyTotal(readings: [(Date, Double)]) -> (total: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -29, to: mostRecentDate)!
        let total = readings
            .filter { $0.0 >= startDate && $0.0 <= mostRecentDate }
            .map { $0.1 }
            .reduce(0, +)
        return (total, startDate, mostRecentDate)
    }
    
        // MARK: - Average of Day, Week, and Month
    func getDailyAverage(readings: [(Date, Double)]) -> (average: Double, date: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date()) }
        let average = calculateAverage(readings: readings.filter { Calendar.current.isDate($0.0, inSameDayAs: mostRecentDate) })
        return (average, mostRecentDate)
    }

    func getWeeklyAverage(readings: [(Date, Double)]) -> (average: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: mostRecentDate)!
        let average = calculateAverage(readings: readings.filter { $0.0 >= startDate && $0.0 <= mostRecentDate })
        return (average, startDate, mostRecentDate)
    }

    func getMonthlyAverage(readings: [(Date, Double)]) -> (average: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -29, to: mostRecentDate)!
        let average = calculateAverage(readings: readings.filter { $0.0 >= startDate && $0.0 <= mostRecentDate })
        return (average, startDate, mostRecentDate)
    }

    private func calculateAverage(readings: [(Date, Double)]) -> Double {
        guard !readings.isEmpty else { return 0.0 }

        let totalSum = readings.reduce(0.0) { $0 + $1.1 }
        return totalSum / Double(readings.count)
    }
    
        // MARK: - Total (Sum) of Day, Week, and Month for kilometer
    func getDailyDistanceTotal(readings: [(Date, Double)]) -> (total: Double, date: Date) {
        let today = Calendar.current.startOfDay(for: Date())
        let totalMeters = readings
            .filter { Calendar.current.isDate($0.0, inSameDayAs: today) }
            .map { $0.1 }
            .reduce(0, +)
        let totalKilometers = totalMeters / 1000.0
        return (totalKilometers, today)
    }

    func getWeeklyDistanceTotal(readings: [(Date, Double)]) -> (total: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: mostRecentDate)!
        let totalMeters = readings
            .filter { $0.0 >= startDate && $0.0 <= mostRecentDate }
            .map { $0.1 }
            .reduce(0, +)
        let totalKilometers = totalMeters / 1000.0
        return (totalKilometers, startDate, mostRecentDate)
    }

    func getMonthlyDistanceTotal(readings: [(Date, Double)]) -> (total: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -29, to: mostRecentDate)!
        let totalMeters = readings
            .filter { $0.0 >= startDate && $0.0 <= mostRecentDate }
            .map { $0.1 }
            .reduce(0, +)
        let totalKilometers = totalMeters / 1000.0
        return (totalKilometers, startDate, mostRecentDate)
    }
    
        // MARK: - Average of Day, Week, and Month
    func getDailyDistanceAverage(readings: [(Date, Double)]) -> (average: Double, date: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date()) }
        let average = calculateDistanceAverage(readings: readings.filter { Calendar.current.isDate($0.0, inSameDayAs: mostRecentDate) })
        return (average, mostRecentDate)
    }

    func getWeeklyDistanceAverage(readings: [(Date, Double)]) -> (average: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: mostRecentDate)!
        let average = calculateDistanceAverage(readings: readings.filter { $0.0 >= startDate && $0.0 <= mostRecentDate })
        return (average, startDate, mostRecentDate)
    }

    func getMonthlyDistanceAverage(readings: [(Date, Double)]) -> (average: Double, startDate: Date, endDate: Date) {
        guard let mostRecentDate = readings.first?.0 else { return (0.0, Date(), Date()) }
        let startDate = Calendar.current.date(byAdding: .day, value: -29, to: mostRecentDate)!
        let average = calculateDistanceAverage(readings: readings.filter { $0.0 >= startDate && $0.0 <= mostRecentDate })
        return (average, startDate, mostRecentDate)
    }

    private func calculateDistanceAverage(readings: [(Date, Double)]) -> Double {
        guard !readings.isEmpty else { return 0.0 }

        let totalSum = readings.reduce(0.0) { $0 + $1.1 }
        let averageKilometers = totalSum / 1000.0
        return averageKilometers / Double(readings.count)
    }
    
}


extension HealthDataViewModel {
    
}
