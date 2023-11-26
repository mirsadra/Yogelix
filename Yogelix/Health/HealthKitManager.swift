//  HealthKitManager.swift
import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Safely unwrap HKSampleType and HKCharacteristicType
        guard let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let heightType = HKObjectType.quantityType(forIdentifier: .height),
              let walkingRunningDistanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              let mindfulSessionType = HKObjectType.categoryType(forIdentifier: .mindfulSession),
              let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth) else {
            completion(false, NSError(domain: "HealthKit", code: 100, userInfo: [NSLocalizedDescriptionKey: "Unable to create health data types"]))
            return
        }
        
        let sampleTypes: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            bodyMassIndexType,
            heartRateType,
            heightType,
            walkingRunningDistanceType,
            activeEnergyBurnedType,
            sleepAnalysisType,
            mindfulSessionType
        ]
        
        let characteristicTypes: Set<HKCharacteristicType> = [
            biologicalSexType,
            dateOfBirthType
        ]
        
        let readTypes: Set<HKObjectType> = Set(sampleTypes).union(Set(characteristicTypes))
        
        let writeTypes: Set<HKSampleType> = [
            HKObjectType.workoutType(), // For writing yoga workouts
            heartRateType,          // For writing heart rate data
            activeEnergyBurnedType      //for writing calories burnt
        ]
        
        if !Thread.isMainThread {
            print("Not on the main thread. Dispatching requestAuthorization to the main thread.")
            DispatchQueue.main.async {
                self.healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
                    completion(success, error)
                }
            }
        } else {
            self.healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
                completion(success, error)
            }
        }
    }
    
    // MARK: - Check for authorization before saving data
    // Check authorization status for heart rate
    func isAuthorizedForHeartRate() -> Bool {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return false
        }
        return healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized
    }
    
    // Check authorization status for workouts
    func isAuthorizedForWorkouts() -> Bool {
        let workoutType = HKObjectType.workoutType()
        return healthStore.authorizationStatus(for: workoutType) == .sharingAuthorized
    }
    
    func isAuthorizedForActiveEnergyBurned() -> Bool {
        guard let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return false
        }
        return healthStore.authorizationStatus(for: activeEnergyBurnedType) == .sharingAuthorized
    }
    
    
    // Create and save heart rate sample
    func saveHeartRateSample(heartRate: Double, startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        // Ensure the heart rate type is available
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, NSError(domain: "HealthKit", code: 101, userInfo: [NSLocalizedDescriptionKey: "Heart rate type is not available"]))
            return
        }
        
        // Create a heart rate quantity
        let heartRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: heartRate)
        
        // Create a sample for the heart rate data
        let heartRateSample = HKQuantitySample(type: heartRateType, quantity: heartRateQuantity, start: startDate, end: endDate)
        
        // Save the heart rate sample
        healthStore.save(heartRateSample) { success, error in
            completion(success, error)
        }
    }
    
    // Create and save workout sample (Yoga workout + calories burned)
    func saveYogaWorkout(startDate: Date, endDate: Date, caloriesBurned: Double?, distance: Double?, completion: @escaping (HKWorkout?, Error?) -> Void) {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .yoga
        workoutConfiguration.locationType = .unknown // Adjust based on your app's needs
        
        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: HKDevice.local())
        
        builder.beginCollection(withStart: startDate) { success, error in
            guard success else {
                completion(nil, error)
                return
            }
            
            // Add calories burned and distance, if available
            var samples = [HKSample]()
            if let calories = caloriesBurned {
                let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
                let calorieSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: calorieQuantity, start: startDate, end: endDate)
                samples.append(calorieSample)
            }
            if let distance = distance {
                let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distance)
                let distanceSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!, quantity: distanceQuantity, start: startDate, end: endDate)
                samples.append(distanceSample)
            }
            
            builder.add(samples) { success, error in
                guard success else {
                    completion(nil, error)
                    return
                }
                
                builder.endCollection(withEnd: endDate) { success, error in
                    guard success else {
                        completion(nil, error)
                        return
                    }
                    
                    builder.finishWorkout { workout, error in
                        completion(workout, error)
                    }
                }
            }
        }
    }
    
    // Read body mass
    func readBodyMass(completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        guard let bodyMassIndexType = HKSampleType.quantityType(forIdentifier: .bodyMassIndex) else {
            completion(nil, NSError(domain: "HealthKit", code: 200, userInfo: [NSLocalizedDescriptionKey: "Body Mass type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: bodyMassIndexType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples?.first as? HKQuantitySample, error)
        }
        healthStore.execute(query)
    }
    

    // MARK: - Read Heart & Calculations
    func readHeartRate(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 201, userInfo: [NSLocalizedDescriptionKey: "Heart Rate type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: mostRecentPredicate, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples as? [HKQuantitySample], error)
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Read Height
    func readHeight(completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        guard let heightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height) else {
            completion(nil, NSError(domain: "HealthKit", code: 202, userInfo: [NSLocalizedDescriptionKey: "Height type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heightType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples?.first as? HKQuantitySample, error)
        }
        healthStore.execute(query)
    }
    
    func readHeartRateWeeklyAverage(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 202, userInfo: [NSLocalizedDescriptionKey: "Heart Rate type is not available"]))
            return
        }
        
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        let predicate = HKQuery.predicateForSamples(withStart: sevenDaysAgo, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var dailyHeartRateAverages: [(Date, Double)] = []
            var currentDate: Date?
            var totalHeartRate: Double = 0
            var count: Double = 0
            
            if let heartRateSamples = samples as? [HKQuantitySample] {
                for sample in heartRateSamples {
                    if let date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: sample.startDate) {
                        if currentDate != date {
                            if let current = currentDate {
                                let average = totalHeartRate / count
                                dailyHeartRateAverages.append((current, average))
                            }
                            
                            currentDate = date
                            totalHeartRate = 0
                            count = 0
                        }
                        
                        totalHeartRate += sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                        count += 1
                    }
                }
                
                if let current = currentDate {
                    let average = totalHeartRate / count
                    dailyHeartRateAverages.append((current, average))
                }
            }
            
            completion(dailyHeartRateAverages, nil)
        }
        healthStore.execute(query)
    }
    
    // Analyze trends over time for heart rate (e.g., monthly average)
    func readMonthlyHeartRateTrends(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 203, userInfo: [NSLocalizedDescriptionKey: "Heart Rate type is not available"]))
            return
        }
        
        // Set up the date components for the query
        var interval = DateComponents()
        interval.month = 1
        
        let calendar = Calendar.current
        let currentDate = Date()
        let startDate = calendar.date(byAdding: .year, value: -1, to: currentDate) // 1 year ago
        guard let anchorDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate) else {
            completion(nil, NSError(domain: "HealthKit", code: 204, userInfo: [NSLocalizedDescriptionKey: "Could not create anchor date for query"]))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: currentDate, options: .strictStartDate)
        
        // Create the query to calculate the monthly averages
        let query = HKStatisticsCollectionQuery(quantityType: heartRateType,
                                                quantitySamplePredicate: predicate,
                                                options: [.discreteAverage],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Set the results handler
        query.initialResultsHandler = { query, results, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            var monthlyAverages: [(Date, Double)] = []
            let endDate = Date()
            
            results?.enumerateStatistics(from: startDate!, to: endDate) { statistics, stop in
                if let averageQuantity = statistics.averageQuantity() {
                    let averageHeartRate = averageQuantity.doubleValue(for: HKUnit(from: "count/min"))
                    let date = statistics.startDate
                    monthlyAverages.append((date, averageHeartRate))
                }
            }
            
            completion(monthlyAverages, nil)
        }
        
        // Execute the query
        healthStore.execute(query)
    }
    
    // Calculate Heart Rate Recovery (HRR)
    func calculateHeartRateRecovery(peakHeartRate: Double, recoveryHeartRate: Double) -> Result<Double, Error> {
        // Ensure that the peak heart rate is higher than the recovery heart rate
        guard peakHeartRate > recoveryHeartRate else {
            return .failure(NSError(domain: "HealthKitManager",
                                    code: 300,
                                    userInfo: [NSLocalizedDescriptionKey: "Peak heart rate must be greater than recovery heart rate."]))
        }
        
        // Calculate the heart rate recovery
        let heartRateRecovery = peakHeartRate - recoveryHeartRate
        
        // Return the result
        return .success(heartRateRecovery)
    }
    
    
    // Calculate Resting Heart Rate (RHR)
    func readRestingHeartRate(completion: @escaping (Double?, Error?) -> Void) {
        guard let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate) else {
            completion(nil, NSError(domain: "HealthKit", code: 203, userInfo: [NSLocalizedDescriptionKey: "Resting Heart Rate type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: restingHeartRateType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let samples = samples, let mostRecentSample = samples.first as? HKQuantitySample else {
                completion(nil, error)
                return
            }
            
            let restingHeartRate = mostRecentSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            completion(restingHeartRate, nil)
        }
        
        healthStore.execute(query)
    }
    
    // Detect anomalies in heart rate data
    func detectAnomaliesInHeartRateData(heartRateSamples: [HKQuantitySample], completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        let heartRates = heartRateSamples.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
        let meanHeartRate = heartRates.reduce(0, +) / Double(heartRates.count)
        let squaredDiffs = heartRates.map { ($0 - meanHeartRate) * ($0 - meanHeartRate) }
        let varianceHeartRate = squaredDiffs.reduce(0, +) / Double(heartRates.count)
        let standardDeviation = sqrt(varianceHeartRate)
        
        let anomalyThreshold = standardDeviation * 3 // This is a common threshold for anomaly detection
        let anomalies = heartRateSamples.filter {
            let heartRateValue = $0.quantity.doubleValue(for: HKUnit(from: "count/min"))
            return abs(heartRateValue - meanHeartRate) > anomalyThreshold
        }
        
        completion(anomalies, nil)
    }
    
    // Correlate Heart Rate with Sleep Analysis
    func correlateHeartRateWithSleep(heartRateSamples: [HKQuantitySample], sleepSamples: [HKCategorySample], completion: @escaping (Double?, Error?) -> Void) {
        // Extract heart rates and sleep values with corresponding dates
        let heartRates = heartRateSamples.map { ($0.startDate, $0.quantity.doubleValue(for: HKUnit(from: "count/min"))) }
        let sleepValues = sleepSamples.map { ($0.startDate, $0.value == HKCategoryValueSleepAnalysis.inBed.rawValue ? 1 : 0) }
        
        // Ensure we have data to compare
        guard !heartRates.isEmpty && !sleepValues.isEmpty else {
            completion(nil, NSError(domain: "HealthKitManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Insufficient data for correlation analysis"]))
            return
        }
        
        // Match heart rate and sleep data by date
        var matchedData: [(heartRate: Double, sleep: Int)] = []
        for heartRate in heartRates {
            for sleep in sleepValues where Calendar.current.isDate(heartRate.0, inSameDayAs: sleep.0) {
                matchedData.append((heartRate: heartRate.1, sleep: sleep.1))
                break
            }
        }
        
        // Calculate Pearson correlation coefficient
        let n = Double(matchedData.count)
        let sum1 = matchedData.map { $0.heartRate }.reduce(0, +)
        let sum2 = matchedData.map { Double($0.sleep) }.reduce(0, +)
        let sum1Sq = matchedData.map { $0.heartRate * $0.heartRate }.reduce(0, +)
        let sum2Sq = matchedData.map { Double($0.sleep) * Double($0.sleep) }.reduce(0, +)
        let pSum = matchedData.map { $0.heartRate * Double($0.sleep) }.reduce(0, +)
        let num = pSum - (sum1 * sum2 / n)
        let den = sqrt((sum1Sq - pow(sum1, 2) / n) * (sum2Sq - pow(sum2, 2) / n))
        
        if den == 0 {
            completion(nil, NSError(domain: "HealthKitManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "Denominator is zero, correlation cannot be computed"]))
            return
        }
        
        let correlation = num / den
        completion(correlation, nil)
    }
    

    
    // MARK: - Read Sleep Analysis
    // Read sleep analysis & calculate sleep metrics
    func readSleepAnalysis(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        guard let sleepAnalysisType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthKit", code: 203, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type is not available"]))
            return
        }
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepAnalysisType, predicate: mostRecentPredicate, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, error in
            guard let samples = samples as? [HKCategorySample], error == nil else {
                completion(nil, error)
                return
            }
            let sleepMetrics = self.calculateSleepMetrics(from: samples)
            print("Sleep Quality: \(sleepMetrics.sleepQuality)")
            print("Sleep Efficiency: \(sleepMetrics.sleepEfficiency)")
            print("Number of Interruptions: \(sleepMetrics.interruptions)")
            
            completion(samples, nil)
        }
        healthStore.execute(query)
    }
    
    func calculateSleepMetrics(from samples: [HKCategorySample]) -> (sleepQuality: Double, sleepEfficiency: Double, interruptions: Int) {
        var totalSleepTime: TimeInterval = 0
        var totalTimeInBed: TimeInterval = 0
        var interruptions: Int = 0
        var lastSleepEnd: Date? = nil
        
        for sample in samples {
            let duration = sample.endDate.timeIntervalSince(sample.startDate)
            switch sample.value {
                case HKCategoryValueSleepAnalysis.asleepUnspecified.rawValue:
                    totalSleepTime += duration
                    if let lastEnd = lastSleepEnd, sample.startDate.timeIntervalSince(lastEnd) > 0 {
                        interruptions += 1
                    }
                    lastSleepEnd = sample.endDate
                case HKCategoryValueSleepAnalysis.inBed.rawValue:
                    totalTimeInBed += duration
                default: break
            }
        }
        
        // Sleep Quality is the ratio of the total sleep time to the total time in bed.
        let sleepQuality = (totalTimeInBed > 0) ? (totalSleepTime / totalTimeInBed) : 0
        
        // Sleep Efficiency is the percentage of time in bed that the user is actually asleep.
        let sleepEfficiency = (totalTimeInBed > 0) ? (totalSleepTime / totalTimeInBed) * 100 : 0
        
        // Number of Interruptions during the sleep. Assumes any time gap between asleep samples is an interruption.
        
        return (sleepQuality, sleepEfficiency, interruptions)
    }
    
    // Read Walking/Running Distance
    func readWalkingRunningDistance(completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let distanceType = HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(nil, NSError(domain: "HealthKit", code: 204, userInfo: [NSLocalizedDescriptionKey: "Distance Walking/Running type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: distanceType, predicate: mostRecentPredicate, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples as? [HKQuantitySample], error)
        }
        
        healthStore.execute(query)
    }
    
    // Read Mindful Sessions
    func readMindfulSessions(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        guard let mindfulType = HKSampleType.categoryType(forIdentifier: .mindfulSession) else {
            completion(nil, NSError(domain: "HealthKit", code: 205, userInfo: [NSLocalizedDescriptionKey: "Mindful Session type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: mindfulType, predicate: mostRecentPredicate, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples as? [HKCategorySample], error)
        }
        
        healthStore.execute(query)
    }
    
    // Read Biological Sex
    func readBiologicalSex(completion: @escaping (HKBiologicalSexObject?, Error?) -> Void) {
        do {
            let biologicalSex = try healthStore.biologicalSex()
            completion(biologicalSex, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    // Read Date of Birth
    func readDateOfBirth(completion: @escaping (DateComponents?, Error?) -> Void) {
        do {
            let dateOfBirthComponents = try healthStore.dateOfBirthComponents()
            completion(dateOfBirthComponents, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    // MARK: - Fetching
    
    func fetchTotalActiveEnergyBurned(completion: @escaping (Double?, Error?) -> Void) {
        guard let energyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil, NSError(domain: "HealthKit", code: 206, userInfo: [NSLocalizedDescriptionKey: "Active Energy Burned type is not available"]))
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: energyBurnedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, error == nil else {
                completion(nil, error)
                return
            }
            let total = result.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie())
            completion(total, nil)
        }
        
        healthStore.execute(query)
    }
    
    func fetchTotalExerciseMinutes(completion: @escaping (Double?, Error?) -> Void) {
        guard let exerciseTimeType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
            completion(nil, NSError(domain: "HealthKit", code: 207, userInfo: [NSLocalizedDescriptionKey: "Exercise Time type is not available"]))
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: exerciseTimeType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, error == nil else {
                completion(nil, error)
                return
            }
            let total = result.sumQuantity()?.doubleValue(for: HKUnit.minute())
            completion(total, nil)
        }
        
        healthStore.execute(query)
    }
    
    
    // MARK: - Core Data Integration
    
    func saveHealthDataToCoreData(stepCount: Double, heartRate: Double) {
        let context = PersistenceController.shared.container.viewContext
        let newEntry = HealthData(context: context)
        newEntry.date = Date()
        newEntry.stepCount = stepCount
        newEntry.heartRate = heartRate
        do {
            try context.save()
        } catch {
            // Handle the error appropriately
        }
    }
}

