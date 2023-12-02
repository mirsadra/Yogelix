//  QuantityTypeManager.swift
import Foundation
import HealthKit


class QuantityTypeManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Authorization Request: Read Only
    private func healthDataTypes() -> (read: Set<HKObjectType>, error: Error?) {
        guard let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let heightType = HKObjectType.quantityType(forIdentifier: .height),
              let walkingRunningDistanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation),
              let exerciseMinutesType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
            let error = NSError(domain: "HealthKit", code: 100, userInfo: [NSLocalizedDescriptionKey: "Unable to create quantity data types"])
            return (Set(), error)
        }
        
        let readTypes: Set<HKObjectType> = [
            bodyMassIndexType,
            heartRateType,
            heightType,
            walkingRunningDistanceType,
            activeEnergyBurnedType,
            exerciseMinutesType,
            oxygenSaturationType
        ]
        
        return (readTypes, nil)
    }
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, CustomError?) -> Void) {
        let (readTypes, _) = healthDataTypes()
        
        func performRequest() {
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
                if success {
                    completion(true, nil)
                } else {
                    completion(false, .authorizationFailed)
                }
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
    func isAuthorizedForBMI() -> Bool {
        guard let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex) else {
            return false
        }
        return healthStore.authorizationStatus(for: bodyMassIndexType) == .sharingAuthorized
    }
    
    func isAuthorizedForHeartRate() -> Bool {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return false
        }
        return healthStore.authorizationStatus(for: heartRateType) == .sharingAuthorized
    }
    
    func isAuthorizedForHeight() -> Bool {
        guard let heightType = HKObjectType.quantityType(forIdentifier: .height) else {
            return false
        }
        return healthStore.authorizationStatus(for: heightType) == .sharingAuthorized
    }
    
    func isAuthorizedForWalkingRunningDistance() -> Bool {
        guard let walkingRunningDistanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return false
        }
        return healthStore.authorizationStatus(for: walkingRunningDistanceType) == .sharingAuthorized
    }
    
    func isAuthorizedForActiveEnergyBurned() -> Bool {
        guard let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return false
        }
        return healthStore.authorizationStatus(for: activeEnergyBurnedType) == .sharingAuthorized
    }
    
    func isAuthorizedForExerciseMinutes() -> Bool {
        guard let exerciseMinutesType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime) else {
            return false
        }
        return healthStore.authorizationStatus(for: exerciseMinutesType) == .sharingAuthorized
    }
    
    func isAuthorizedForOxygenSaturation() -> Bool {
        guard let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else {
            return false
        }
        return healthStore.authorizationStatus(for: oxygenSaturationType) == .sharingAuthorized
    }
    
    // MARK: - Reading BMI and Height (using `executeSingleValueQuery`)
    // Body Mass Index
    func readBodyMassIndex(completion: @escaping (Double?, Date?, Error?) -> Void) {
        let bodyMassIndexIdentifier = HKQuantityTypeIdentifier.bodyMassIndex
        
        executeSingleValueQuery(
            for: bodyMassIndexIdentifier,
            unit: HKUnit(from: ""),
            errorDomainCode: 101
        ) { (value, date, error) in
            completion(value, date, error)
        }
    }
    
    // Height
    func readHeight(completion: @escaping (Double?, Date?, Error?) -> Void) {
        let heightIdentifier = HKQuantityTypeIdentifier.height
        
        executeSingleValueQuery(
            for: heightIdentifier,
            unit: HKUnit.meter(),
            errorDomainCode: 101
        ) { (value, date, error) in
            completion(value, date, error)
        }
    }
    
    // MARK: - Reading Active Energy Burned (using `executeCurrentDayCumulativeSumQuery` and `executeLastWeekCumulativeSumQuery`)
    // Read Active Energy Burned for Current Day
    func readCurrentDayActiveEnergyBurned(completion: @escaping (Double?, Error?) -> Void) {
        let activeEnergyBurnedIdentifier = HKQuantityTypeIdentifier.activeEnergyBurned
        
        executeCurrentDayCumulativeSumQuery(
            for: activeEnergyBurnedIdentifier,
            unit: HKUnit.kilocalorie()
        ) { (total, error) in
            completion(total, error)
        }
    }

    // Read Active Energy Burned for Last 7 Days
    func readLastWeekActiveEnergyBurned(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        let activeEnergyBurnedIdentifier = HKQuantityTypeIdentifier.activeEnergyBurned
        
        executeLastWeekCumulativeSumQuery(
            for: activeEnergyBurnedIdentifier,
            unit: HKUnit.kilocalorie()
        ) { (data, error) in
            completion(data, error)
        }
    }

    // MARK: - Reading Walking/Running Distance (using `executeCurrentDayCumulativeSumQuery` and `executeLastWeekCumulativeSumQuery`)
    // Read Walking/Running Distance for Current Day
    func readCurrentDayWalkingRunningDistance(completion: @escaping (Double?, Error?) -> Void) {
        let walkingRunningDistanceIdentifier = HKQuantityTypeIdentifier.distanceWalkingRunning
        
        executeCurrentDayCumulativeSumQuery(
            for: walkingRunningDistanceIdentifier,
            unit: HKUnit.meter()
        ) { (total, error) in
            completion(total, error)
        }
    }

    // Read Walking/Running Distance for Last 7 Days
    func readLastWeekWalkingRunningDistance(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        let walkingRunningDistanceIdentifier = HKQuantityTypeIdentifier.distanceWalkingRunning
        
        executeLastWeekCumulativeSumQuery(
            for: walkingRunningDistanceIdentifier,
            unit: HKUnit.meter()
        ) { (data, error) in
            completion(data, error)
        }
    }
    
    // MARK: - Reading Exercise Time (using `executeCurrentDayCumulativeSumQuery` and `executeLastWeekCumulativeSumQuery`)
    // Read Exercise Time for Current Day
    func readCurrentDayExerciseMinutes(completion: @escaping (Double?, Error?) -> Void) {
        let exerciseMinutesIdentifier = HKQuantityTypeIdentifier.appleExerciseTime
        
        executeCurrentDayCumulativeSumQuery(
            for: exerciseMinutesIdentifier,
            unit: HKUnit.minute()
        ) { (total, error) in
            completion(total, error)
        }
    }

    // Read Exercise Time for Last 7 Days
    func readLastWeekExerciseMinutes(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        let exerciseMinutesIdentifier = HKQuantityTypeIdentifier.appleExerciseTime
        
        executeLastWeekCumulativeSumQuery(
            for: exerciseMinutesIdentifier,
            unit: HKUnit.minute()
        ) { (data, error) in
            completion(data, error)
        }
    }
    
    // MARK: - Reading Heart Rate (Discrete: average, max, min)
    func readCurrentDayHeartRate(completion: @escaping (Double?, Double?, Double?, Error?) -> Void) {
        let heartRateIdentifier = HKQuantityTypeIdentifier.heartRate
        let heartRateUnit = HKUnit(from: "count/min")
        let options: HKStatisticsOptions = [.discreteAverage, .discreteMin, .discreteMax]

        executeCurrentDayDiscreteStatisticsQuery(
            for: heartRateIdentifier,
            unit: heartRateUnit,
            options: options,
            completion: completion
        )
    }

    func readLastWeekHeartRate(completion: @escaping ([Date: (Double?, Double?, Double?)]?, Error?) -> Void) {
        let heartRateIdentifier = HKQuantityTypeIdentifier.heartRate
        let heartRateUnit = HKUnit(from: "count/min")
        let options: HKStatisticsOptions = [.discreteAverage, .discreteMin, .discreteMax]

        executeLastWeekDiscreteStatisticsQuery(
            for: heartRateIdentifier,
            unit: heartRateUnit,
            options: options,
            completion: completion
        )
    }

    func readCurrentDayOxygenSaturation(completion: @escaping (Double?, Double?, Double?, Error?) -> Void) {
        let oxygenSaturationIdentifier = HKQuantityTypeIdentifier.oxygenSaturation
        let oxygenSaturationUnit = HKUnit.percent()
        let options: HKStatisticsOptions = [.discreteAverage, .discreteMin, .discreteMax]

        executeCurrentDayDiscreteStatisticsQuery(
            for: oxygenSaturationIdentifier,
            unit: oxygenSaturationUnit,
            options: options,
            completion: completion
        )
    }

    func readLastWeekOxygenSaturation(completion: @escaping ([Date: (Double?, Double?, Double?)]?, Error?) -> Void) {
        let oxygenSaturationIdentifier = HKQuantityTypeIdentifier.oxygenSaturation
        let oxygenSaturationUnit = HKUnit.percent()
        let options: HKStatisticsOptions = [.discreteAverage, .discreteMin, .discreteMax]

        executeLastWeekDiscreteStatisticsQuery(
            for: oxygenSaturationIdentifier,
            unit: oxygenSaturationUnit,
            options: options,
            completion: completion
        )
    }

    // MARK: - Private Helper Methods
    private func executeSingleValueQuery(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        errorDomainCode: Int,
        completion: @escaping (Double?, Date?, Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, nil, NSError(domain: "HealthKit", code: errorDomainCode, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: quantityType, predicate: predicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            if let quantitySample = samples?.first as? HKQuantitySample {
                let value = quantitySample.quantity.doubleValue(for: unit)
                let date = quantitySample.startDate
                completion(value, date, nil)
            } else {
                // No valid sample found
                completion(nil, nil, NSError(domain: "HealthKit", code: 101, userInfo: [NSLocalizedDescriptionKey: "No valid sample found"]))
            }
        }
        healthStore.execute(query)
    }
    
    
    private func executeCurrentDayCumulativeSumQuery(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        completion: @escaping (Double?, Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: 1001, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
            if let error = error {
                completion(nil, error)
                return
            }

            let total = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
            completion(total, nil)
        }
        healthStore.execute(query)
    }
    
    private func executeLastWeekCumulativeSumQuery(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        completion: @escaping ([Date: Double]?, Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: 1002, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let calendar = Calendar.current
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) else {
            completion(nil, NSError(domain: "HealthKit", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Cannot calculate start date"]))
            return
        }

        let anchorDate = calendar.startOfDay(for: startDate)
        let daily = DateComponents(day: 1)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)

        query.initialResultsHandler = { _, results, error in
            if let error = error {
                completion(nil, error)
                return
            }

            var data = [Date: Double]()
            results?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let total = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0
                data[statistics.startDate] = total
            }
            completion(data, nil)
        }
        healthStore.execute(query)
    }
    
    
    private func executeCurrentDayDiscreteStatisticsQuery(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        options: HKStatisticsOptions,
        completion: @escaping (Double?, Double?, Double?, Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, nil, nil, NSError(domain: "HealthKit", code: 1004, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options) { _, statistics, error in
            if let error = error {
                completion(nil, nil, nil, error)
                return
            }

            let averageValue = statistics?.averageQuantity()?.doubleValue(for: unit)
            let minValue = statistics?.minimumQuantity()?.doubleValue(for: unit)
            let maxValue = statistics?.maximumQuantity()?.doubleValue(for: unit)

            completion(averageValue, minValue, maxValue, nil)
        }
        healthStore.execute(query)
    }

    
    private func executeLastWeekDiscreteStatisticsQuery(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        options: HKStatisticsOptions,
        completion: @escaping ([Date: (Double?, Double?, Double?)]?, Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "HealthKit", code: 1005, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let calendar = Calendar.current
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: endDate) else {
            completion(nil, NSError(domain: "HealthKit", code: 1006, userInfo: [NSLocalizedDescriptionKey: "Cannot calculate start date"]))
            return
        }

        let anchorDate = calendar.startOfDay(for: startDate)
        let daily = DateComponents(day: 1)

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options, anchorDate: anchorDate, intervalComponents: daily)

        query.initialResultsHandler = { _, results, error in
            if let error = error {
                completion(nil, error)
                return
            }

            var data = [Date: (Double?, Double?, Double?)]()
            results?.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                let average = statistics.averageQuantity()?.doubleValue(for: unit)
                let min = statistics.minimumQuantity()?.doubleValue(for: unit)
                let max = statistics.maximumQuantity()?.doubleValue(for: unit)
                data[statistics.startDate] = (average, min, max)
            }
            completion(data, nil)
        }
        healthStore.execute(query)
    }
    
    // MARK: - Custom Error Handling
    enum CustomError: Error {
        case authorizationFailed
        case workoutSaveFailed
        case workoutSaveBuildFailed
        case workoutReadFailed
        
        var emoji: String {
            switch self {
                case .authorizationFailed:
                    return "🧘🏼‍♀️😞📵"
                case .workoutSaveFailed:
                    return "🧘🏼‍♀️😞📵"
                case .workoutSaveBuildFailed:
                    return "🧘🏼‍♀️😞📵"
                case .workoutReadFailed:
                    return "🧘🏼‍♀️😞📵"
            }
        }
        
        var localizedDescription: String {
            switch self {
                case .authorizationFailed:
                    return "Authorization Failed \(emoji)"
                case .workoutSaveFailed:
                    return "Workout Save Failed \(emoji)"
                case .workoutSaveBuildFailed:
                    return "Failed to Build \(emoji)"
                case .workoutReadFailed:
                    return "Workout Read Failed \(emoji)"
            }
        }
    }
}
