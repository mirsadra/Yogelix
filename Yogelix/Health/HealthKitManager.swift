//  HealthKitManager.swift
import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Health Data Types
    private func healthDataTypes() -> (read: Set<HKObjectType>, write: Set<HKSampleType>, error: Error?) {
        guard let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let heightType = HKObjectType.quantityType(forIdentifier: .height),
              let walkingRunningDistanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation),
              let basalEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned),
              let exerciseMinutesType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
              let standHoursType = HKObjectType.categoryType(forIdentifier: .appleStandHour),
              let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              let mindfulSessionType = HKObjectType.categoryType(forIdentifier: .mindfulSession),
              let biologicalSexType = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
              let dateOfBirthType = HKObjectType.characteristicType(forIdentifier: .dateOfBirth) else {
                return (Set(), Set(), NSError(domain: "HealthKit", code: 100, userInfo: [NSLocalizedDescriptionKey: "Unable to create health data types"]))
        }
        
        let sampleTypes: Set<HKSampleType> = [HKObjectType.workoutType(), bodyMassIndexType, heartRateType, heightType, walkingRunningDistanceType, activeEnergyBurnedType, exerciseMinutesType, standHoursType, oxygenSaturationType, basalEnergyBurnedType, sleepAnalysisType, mindfulSessionType]
        let characteristicTypes: Set<HKCharacteristicType> = [biologicalSexType, dateOfBirthType]
        
        let readTypes = Set(sampleTypes).union(Set(characteristicTypes))
        let writeTypes: Set<HKSampleType> = [HKObjectType.workoutType(), heartRateType, activeEnergyBurnedType]

        return (readTypes, writeTypes, nil)
    }
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let (readTypes, writeTypes, error) = healthDataTypes()

        if let error = error {
            completion(false, error)
            return
        }

        func performRequest() {
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
                completion(success, error)
            }
        }

        if !Thread.isMainThread {
            print("Not on the main thread. Dispatching requestAuthorization to the main thread.")
            DispatchQueue.main.async(execute: performRequest)
        } else {
            performRequest()
        }
    }

    // MARK: - Authorization Check Methods
    func isAuthorizedForHeartRate() -> Bool {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return false
        }
        return healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized
    }

    func isAuthorizedForWorkouts() -> Bool {
        return healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized
    }

    func isAuthorizedForActiveEnergyBurned() -> Bool {
        guard let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return false
        }
        return healthStore.authorizationStatus(for: activeEnergyBurnedType) == .sharingAuthorized
    }

    // MARK: - Health Data Saving Methods
    func saveHeartRateSample(heartRate: Double, startDate: Date, endDate: Date, completion: @escaping (Bool, Error?) -> Void) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, NSError(domain: "HealthKit", code: 101, userInfo: [NSLocalizedDescriptionKey: "Heart rate type is not available"]))
            return
        }

        let heartRateQuantity = HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: heartRate)
        let heartRateSample = HKQuantitySample(type: heartRateType, quantity: heartRateQuantity, start: startDate, end: endDate)

        healthStore.save(heartRateSample) { success, error in
            completion(success, error)
        }
    }

    func saveYogaWorkout(startDate: Date, endDate: Date, caloriesBurned: Double?, distance: Double?, completion: @escaping (HKWorkout?, Error?) -> Void) {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .yoga
        workoutConfiguration.locationType = .unknown

        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: HKDevice.local())
        builder.beginCollection(withStart: startDate) { success, error in
            guard success else {
                completion(nil, error)
                return
            }

            var samples = [HKSample]()
            if let calories = caloriesBurned {
                let calorieQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
                let calorieSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: calorieQuantity, start: startDate, end: endDate)
                samples.append(calorieSample)
            }
            if let distanceValue = distance {
                let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distanceValue)
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

    // MARK: - Data Reading Methods

    // Body Mass Index
    func readBodyMassIndex(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .bodyMassIndex, unit: HKUnit(from: ""), limit: 14, completion: completion)
    }

    // Heart Rate
    func readHeartRate(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .heartRate, unit: HKUnit(from: "count/min"), limit: 14, completion: completion)
    }
    
    // Height
    func readHeight(completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        executeSingleSampleQuery(for: .height, completion: completion)
    }

    // Walking/Running Distance
    func readWalkingRunningDistance(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .distanceWalkingRunning, unit: HKUnit.meter(), limit: 14, completion: completion)
    }
    
    // Active Energy Burned
    func readActiveEnergyBurned(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .activeEnergyBurned, unit: HKUnit.kilocalorie(), limit: 700, completion: completion)
    }

    // Oxygen Saturation
    func readOxygenSaturation(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .oxygenSaturation, unit: HKUnit.percent(), limit: 14, completion: completion)
    }
    
    // Basal Energy Burned
    func readBasalEnergyBurned(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .basalEnergyBurned, unit: HKUnit.kilocalorie(), limit: 14, completion: completion)
    }
    
    // Excercise Time (Apple Exercise Time)
    func readExerciseMinutes(completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        executeQuantitySampleQueryWithDate(for: .appleExerciseTime, unit: HKUnit.minute(), limit: 14, completion: completion)
    }
    
    // Stand Hours (Apple Stand Hour)
    func readStandHours(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        executeCategorySampleQuery(for: .appleStandHour, limit: 15, completion: completion)
    }

    // Mindful Sessions
    func readMindfulSessions(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        executeCategorySampleQuery(for: .mindfulSession, limit: 10, completion: completion)
    }

    // Biological Sex
    func readBiologicalSex(completion: @escaping (HKBiologicalSexObject?, Error?) -> Void) {
        do {
            let biologicalSex = try healthStore.biologicalSex()
            completion(biologicalSex, nil)
        } catch {
            completion(nil, error)
        }
    }

    // Date of Birth
    func readDateOfBirth(completion: @escaping (DateComponents?, Error?) -> Void) {
        do {
            let dateOfBirthComponents = try healthStore.dateOfBirthComponents()
            completion(dateOfBirthComponents, nil)
        } catch {
            completion(nil, error)
        }
    }

    // Sleep Analysis
    func readSleepAnalysis(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        executeCategorySampleQuery(for: .sleepAnalysis, limit: 10, completion: completion)
    }
    
    // MARK: - More complex
    
    // Fetch Total Active Energy Burned
    func readTotalActiveEnergyBurned(completion: @escaping (Double?, Error?) -> Void) {
        executeTotalStatistics(for: .activeEnergyBurned, unit: HKUnit.kilocalorie(), errorDomainCode: 206, completion: completion)
    }
    
    // Fetch Total Exercise Minutes
    func readTotalExerciseMinutes(completion: @escaping (Double?, Error?) -> Void) {
        executeTotalStatistics(for: .appleExerciseTime, unit: HKUnit.minute(), errorDomainCode: 206, completion: completion)
    }

    // Correlate Heart Rate with Sleep Analysis
    func correlateHeartRateWithSleep(heartRateSamples: [HKQuantitySample], sleepSamples: [HKCategorySample], completion: @escaping (Double?, Error?) -> Void) {
        // [Correlation calculation logic remains the same as provided in the original code snippet]
    }

    // Query for Workouts
    func queryForWorkouts(completion: @escaping ([HKWorkout]?) -> Void) {
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .yoga)
        executeWorkoutQuery(predicate: workoutPredicate, completion: completion)
    }

    // MARK: - Private Helper Methods
    
    private func executeQuantitySampleQueryWithDate(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, limit: Int, completion: @escaping ([(Date, Double)]?, Error?) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: 200, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }

            let resultsWithDate = samples?.compactMap { sample in
                (sample as? HKQuantitySample).map { ($0.startDate, $0.quantity.doubleValue(for: unit)) }
            }
            completion(resultsWithDate, nil)
        }

        healthStore.execute(query)
    }

    private func executeQuantitySampleQuery(for identifier: HKQuantityTypeIdentifier, limit: Int, completion: @escaping ([HKQuantitySample]?, Error?) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: 200, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples as? [HKQuantitySample], error)
        }
        healthStore.execute(query)
    }

    private func executeSingleValueQuery(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, errorDomainCode: Int, completion: @escaping (Double?, Error?) -> Void) {
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
                completion(nil, NSError(domain: "HealthKit", code: errorDomainCode, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                let value = (samples?.first as? HKQuantitySample)?.quantity.doubleValue(for: unit)
                completion(value, nil)
            }
            healthStore.execute(query)
        }

    private func executeSingleSampleQuery(for identifier: HKQuantityTypeIdentifier, completion: @escaping (HKQuantitySample?, Error?) -> Void) {
            guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
                completion(nil, NSError(domain: "HealthKit", code: 200, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
                completion(samples?.first as? HKQuantitySample, error)
            }
            healthStore.execute(query)
        }

    private func executeCategorySampleQuery(for identifier: HKCategoryTypeIdentifier, limit: Int, completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
            guard let categoryType = HKCategoryType.categoryType(forIdentifier: identifier) else {
                completion(nil, NSError(domain: "HealthKit", code: 200, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
                return
            }

            let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: categoryType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { _, samples, error in
                completion(samples as? [HKCategorySample], error)
            }
            healthStore.execute(query)
        }

    private func executeWorkoutQuery(predicate: NSPredicate, completion: @escaping ([HKWorkout]?) -> Void) {
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
                completion(results as? [HKWorkout])
            }
            healthStore.execute(query)
        }

    private func executeTotalStatistics(for identifier: HKQuantityTypeIdentifier, unit: HKUnit, errorDomainCode: Int, completion: @escaping (Double?, Error?) -> Void) {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: errorDomainCode, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        // Create a query to retrieve the most recent sample for the specified data type
        let mostRecentSampleQuery = HKSampleQuery(
            sampleType: quantityType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { (query, results, error) in
            guard let sample = results?.first as? HKQuantitySample, error == nil else {
                completion(nil, error)
                return
            }

            // Calculate the date 7 days before the most recent sample
            let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: sample.endDate)

            // Create a statistics query and call the function to execute it
            self.executeStatisticsQuery(
                for: quantityType,
                unit: unit,
                startDate: sevenDaysAgo,
                endDate: sample.endDate,
                completion: completion
            )
        }

        // Execute the mostRecentSampleQuery to retrieve the most recent sample
        healthStore.execute(mostRecentSampleQuery)
    }

    private func executeStatisticsQuery(
        for quantityType: HKQuantityType,
        unit: HKUnit,
        startDate: Date?,
        endDate: Date?,
        completion: @escaping (Double?, Error?) -> Void
    ) {
        guard let startDate = startDate, let endDate = endDate else {
            completion(nil, NSError(domain: "HealthKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid date range"]))
            return
        }

        // Create a predicate to filter data samples within the specified date range
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)

        // Create a statistics query to calculate the cumulative sum for the specified date range
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, error == nil else {
                completion(nil, error)
                return
            }
            let total = result.sumQuantity()?.doubleValue(for: unit)
            completion(total, nil)
        }

        // Execute the statistics query
        healthStore.execute(query)
    }
}



extension HealthKitManager {
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

