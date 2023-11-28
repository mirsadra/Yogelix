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
    
    @Published var summaryHealthItems: [SummaryHealth] = []
    
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
    
    // MARK: - Process Data to create SummaryHealth instances
    

    


    
    func processBMIData() {
        if let bmiReadings = bodyMassIndexReadings, let mostRecentBMI = bmiReadings.last {
            let summaryHealth = SummaryHealth(
                title: "Body Mass Index",
                value: mostRecentBMI.1,  // .1 to access the Double value in the tuple
                unit: "",
                caption: "Most recent reading",
                dataDate: Calendar.current.dateComponents([.year, .month, .day], from: mostRecentBMI.0),
                dateRange: .daily,
                iconName: "figure.scale",
                isInteger: false
            )

            // Add or append the summary to summaryHealthItems
            self.summaryHealthItems.append(summaryHealth)
            return
        }
    }
    
    func processHeartRateData() {
        let weeklyHeartRates = weeklyHeartRateReadings()

        let heartRateSummary = weeklyHeartRates.map { (date, averageRate) in
            return SummaryHealth(
                title: "Weekly Heart Rate",
                value: averageRate,
                unit: "BPM",
                caption: "Average over the week",
                dataDate: Calendar.current.dateComponents([.year, .month, .day], from: date),
                dateRange: .weekly(start: .distantPast, end: .now),
                iconName: "heart.fill",
                isInteger: false
            )
        }

        self.summaryHealthItems += heartRateSummary
    }


    
    func processHealthData() {
        // Example: Processing weekly heart rate readings
        let weeklyHeartRates = weeklyHeartRateReadings()
        let heartRateSummary = convertToSummaryHealth(
            averages: weeklyHeartRates,
            title: "Weekly Heart Rate",
            unit: "BPM",
            iconName: "heart.fill",
            isInteger: false,
            dateRange: .weekly(start: Date(), end: Date())
        )

        // Process other metrics in a similar way and then update summaryHealthItems
        self.summaryHealthItems = heartRateSummary // Add more items as needed
    }
    
    func convertToSummaryHealth(averages: [Date: Double], title: String, unit: String, iconName: String, isInteger: Bool, dateRange: SummaryHealth.DateRange) -> [SummaryHealth] {
        averages.map { (date, value) in
            SummaryHealth(
                title: title,
                value: value,
                unit: unit,
                caption: "Average",
                dataDate: Calendar.current.dateComponents([.year, .month, .day], from: date),
                dateRange: dateRange,
                iconName: iconName,
                isInteger: isInteger
            )
        }
    }
    
    func fetchAllData() {
        fetchBodyMassIndexReadings()
        fetchActivitySummary()
        fetchHeartRateReadings()
        fetchSleepAnalysis()
        fetchHeight()
        fetchActiveEnergyBurnReading()
        
    }
}

// MARK: - Health Data Averages Extension
extension HealthDataViewModel {

    // MARK: - Average Calculations for Data Collections
    private func calculateMetricAverages(metrics: [(Date, Double)]?, component: Calendar.Component) -> [Date: Double] {
        guard let metrics = metrics else { return [:] }

        return calculateAverages(for: metrics, by: component)
    }
    
    func weeklyHeartRateReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: heartRateReadings, component: .weekOfYear)
    }
    
    func monthlyHeartRateReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: heartRateReadings, component: .month)
    }
    
    func weeklyWalkingRunningDistanceReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: walkingRunningDistanceReadings, component: .weekOfYear)
    }

    func monthlyWalkingRunningDistanceReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: walkingRunningDistanceReadings, component: .month)
    }
    
    func weeklyActiveEnergyBurnReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: activeEnergyBurnReadings, component: .weekOfYear)
    }

    func monthlyActiveEnergyBurnReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: activeEnergyBurnReadings, component: .month)
    }
    
    func weeklyOxygenSaturationReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: oxygenSaturationReadings, component: .weekOfYear)
    }

    func monthlyOxygenSaturationReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: oxygenSaturationReadings, component: .month)
    }
    
    func weeklyBasalEnergyBurnReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: basalEnergyBurnReadings, component: .weekOfYear)
    }
    
    func monthlyBasalEnergyBurnReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: basalEnergyBurnReadings, component: .month)
    }
    
    func weeklyExerciseMinutesReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: exerciseMinutesReadings, component: .weekOfYear)
    }

    func monthlyExerciseMinutesReadings() -> [Date: Double] {
        calculateMetricAverages(metrics: exerciseMinutesReadings, component: .month)
    }
    
    // MARK: - General Average Calculation
    private func calculateAverages(for data: [(Date, Double)], by component: Calendar.Component) -> [Date: Double] {
        let groupedData = Dictionary(grouping: data) { tuple in
            let date = Calendar.current.date(from: Calendar.current.dateComponents([component], from: tuple.0.startOfDay())) ?? tuple.0.startOfDay()
            return date
        }


        return groupedData.mapValues { readings in
            let total = readings.reduce(0) { $0 + $1.1 }
            return total / Double(readings.count)
        }
    }
}

private extension Date {
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
}


