//  QuantityTypeManager.swift
import Foundation
import HealthKit

class QuantityTypeManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Authorization Request: Read Only
    private func quantityDataTypes() -> (read: Set<HKObjectType>, error: Error?) {
        guard let bodyMassIndexType = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
              let heightType = HKObjectType.quantityType(forIdentifier: .height),
              let walkingRunningDistanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else {
            let error = NSError(domain: "HealthKit", code: 1000, userInfo: [NSLocalizedDescriptionKey: "Unable to create quantity data types"])
            return (Set(), error)
        }
        
        let readTypes: Set<HKObjectType> = [
            bodyMassIndexType,
            heightType,
            walkingRunningDistanceType,
            activeEnergyBurnedType,
            oxygenSaturationType
        ]
        
        return (readTypes, nil)
    }
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, CustomError?) -> Void) {
        let (readTypes, _) = quantityDataTypes()
        
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
            errorDomainCode: 1001
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
            errorDomainCode: 1002
        ) { (value, date, error) in
            completion(value, date, error)
        }
    }

    func readCurrentDayActiveEnergyBurned(completion: @escaping (Double?, Date?, Error?) -> Void) {
        let activeEnergyBurnedIdentifier = HKQuantityTypeIdentifier.activeEnergyBurned
        
        executeCurrentDayCumulativeSumQuery(
            for: activeEnergyBurnedIdentifier,
            unit: HKUnit.kilocalorie(),
            errorDomainCode: 190
        ) { (total, date, error) in
            let date = Calendar.current.startOfDay(for: Date()) // Set the date as the start of the current day
            completion(total, date, error)
        }
    }

    func readCurrentDayWalkingRunningDistance(completion: @escaping (Double?, Date?, Error?) -> Void) {
        let walkingRunningDistanceIdentifier = HKQuantityTypeIdentifier.distanceWalkingRunning
        
        executeCurrentDayCumulativeSumQuery(
            for: walkingRunningDistanceIdentifier,
            unit: HKUnit.meter(),
            errorDomainCode: 191
        ) { (total, date, error) in
            let date = Calendar.current.startOfDay(for: Date()) // Set the date as the start of the current day
            completion(total, date, error)
        }
    }
    
    func readCurrentDayOxygenSaturation(completion: @escaping (Double?, Date?, Error?) -> Void) {
        let oxygenSaturationIdentifier = HKQuantityTypeIdentifier.oxygenSaturation
        let oxygenSaturationUnit = HKUnit.percent()
        let options: HKStatisticsOptions = [.discreteAverage]
        
        executeCurrentDayDiscreteStatisticsQuery(
            for: oxygenSaturationIdentifier,
            unit: oxygenSaturationUnit,
            options: options
        ) { (result, error) in
            let value = result.0
            let date = result.1
            completion(value, date, error)
        }
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
        errorDomainCode: Int,
        completion: @escaping (Double?, Date?, Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, nil, NSError(domain: "HealthKit", code: errorDomainCode, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            let total = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
            completion(total, nil, nil)
        }
        healthStore.execute(query)
    }
    
    private func executeCurrentDayDiscreteStatisticsQuery(
        for identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        options: HKStatisticsOptions,
        completion: @escaping ((Double?, Date?), Error?) -> Void
    ) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion((nil, nil), NSError(domain: "HealthKit", code: 1004, userInfo: [NSLocalizedDescriptionKey: "\(identifier.rawValue) type is not available"]))
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options) { _, statistics, error in
            if let error = error {
                completion((nil, nil), error)
                return
            }

            let averageValue = statistics?.averageQuantity()?.doubleValue(for: unit)
            let date = statistics?.startDate // or endDate, depending on what you need

            completion((averageValue, date), nil)
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
