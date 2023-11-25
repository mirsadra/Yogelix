//  HealthKitManager.swift
import HealthKit
import UserNotifications

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        // Set for HKSampleType
        let sampleTypes: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        ]

        // Set for HKCharacteristicType
        let characteristicTypes: Set<HKCharacteristicType> = [
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!
        ]

        // Combine all types into a Set<HKObjectType> for the read permission
        let readTypes: Set<HKObjectType> = Set(sampleTypes).union(Set(characteristicTypes))

        // Request Authorization
        healthStore.requestAuthorization(toShare: sampleTypes, read: readTypes) { success, error in
            if !success {
                // Handle the error here.
            }
            completion(success)
        }
    }

    // MARK: - Fetch Heart Rate
    func fetchHeartRateData(completion: @escaping ([HeartRateData]) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion([])
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKQuantitySample] else {
                completion([])
                return
            }
            
            let heartRateData = samples.map { sample -> HeartRateData in
                let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                return HeartRateData(value: heartRate, date: sample.endDate)
            }
            
            DispatchQueue.main.async {
                completion(heartRateData)
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Fetch Step count of the day
    func fetchDailyStepCount(forToday: Date, healthStore: HKHealthStore, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            //            completion(0.0, nil) // No step count type available
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        healthStore.execute(query)
    }
    
    
    // MARK: - Fetch Distance data
    func fetchDistanceData(completion: @escaping ([DistanceData]) -> Void) {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion([])
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: distanceType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKQuantitySample] else {
                completion([])
                return
            }
            
            let distanceData = samples.map { sample -> DistanceData in
                let distance = sample.quantity.doubleValue(for: HKUnit.meter())
                return DistanceData(value: distance, date: sample.endDate)
            }
            
            DispatchQueue.main.async {
                completion(distanceData)
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Fetch Sleep Analysis
    func fetchSleepData(completion: @escaping ([SleepData]) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion([])
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else {
                completion([])
                return
            }
            
            let sleepData = samples.map { sample -> SleepData in
                let sleepType = SleepData.sleepType(from: HKCategoryValueSleepAnalysis(rawValue: sample.value) ?? .inBed)
                let duration = sample.endDate.timeIntervalSince(sample.startDate)
                
                return SleepData(
                    start: sample.startDate,
                    end: sample.endDate,
                    type: sleepType,
                    duration: duration
                )
            }
            DispatchQueue.main.async {
                completion(sleepData)
            }
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Fetch Body Measurements
    func fetchBodyMeasurements(completion: @escaping (BodyMeasurements?) -> Void) {
        let group = DispatchGroup()
        
        var weight: Double?
        var height: Double?
        
        // Fetch Weight
        if let weightType = HKSampleType.quantityType(forIdentifier: .bodyMass) {
            group.enter()
            fetchMostRecentSample(for: weightType) { sample, _ in
                if let quantitySample = sample as? HKQuantitySample {
                    weight = quantitySample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                }
                group.leave()
            }
        }
        
        // Fetch Height
        if let heightType = HKSampleType.quantityType(forIdentifier: .height) {
            group.enter()
            fetchMostRecentSample(for: heightType) { sample, _ in
                if let quantitySample = sample as? HKQuantitySample {
                    height = quantitySample.quantity.doubleValue(for: HKUnit.meter())
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let weight = weight, let height = height {
                let bodyMeasurements = BodyMeasurements(weight: weight, height: height)
                completion(bodyMeasurements)
            } else {
                completion(nil)
            }
        }
    }
    
    // Helper method to fetch the most recent sample of a given type
    private func fetchMostRecentSample(for sampleType: HKSampleType, completion: @escaping (HKSample?, Error?) -> Void) {
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: [])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples?.first, error)
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - Fetch Mindfulness Data
    func fetchMindfulnessData(completion: @escaping (Int) -> Void) {
        guard let mindfulnessType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            completion(0)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: mindfulnessType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            let totalMinutes = samples?.reduce(0) { total, sample in
                total + Int(sample.endDate.timeIntervalSince(sample.startDate) / 60)
            } ?? 0
            
            DispatchQueue.main.async {
                completion(totalMinutes)
            }
        }
        
        healthStore.execute(query)
    }
}

struct HeartRateData: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct StepsData: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct DistanceData: Identifiable {
    let id = UUID()
    let value: Double
    let date: Date
}

struct SleepData: Identifiable {
    let id = UUID()
    let start: Date
    let end: Date
    let type: SleepType
    let duration: TimeInterval
    
    enum SleepType {
        case inBed
        case asleep
        // Add more types as needed
    }
    
    // Helper method to create a SleepType from HKCategoryValueSleepAnalysis
    static func sleepType(from value: HKCategoryValueSleepAnalysis) -> SleepType {
        switch value {
            case .inBed: return .inBed
            case .asleep: return .asleep
            default: return .inBed // or handle unknown case appropriately
        }
    }
}

struct BodyMeasurements {
    let weight: Double  // in kilograms
    let height: Double  // in meters
    // Add BMI calculation if needed
}



// MARK: - HealthKitError

extension HealthKitManager {
    enum HealthKitError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
        case dataNotAvailable
        case unauthorized
        case other(Error)
        
        var errorDescription: String? {
            switch self {
                case .notAvailableOnDevice:
                    return "HealthKit is not available on this device."
                case .dataTypeNotAvailable:
                    return "Requested data type is not available."
                case .dataNotAvailable:
                    return "The requested data is not available."
                case .unauthorized:
                    return "HealthKit authorization was denied."
                case .other(let error):
                    return error.localizedDescription
            }
        }
    }
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

// MARK: - Notification Setup

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        // Handle permission granted or not
    }
}

func scheduleDailyReminder() {
    let content = UNMutableNotificationContent()
    content.title = "Health Check"
    content.body = "Don't forget to check your daily health stats!"
    
    var dateComponents = DateComponents()
    dateComponents.hour = 20 // Example: 8 PM daily
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}

// MARK: - WorkoutKit



// MARK: - Request permission from the user (EXAMPLE)
/*
 let allTypes = Set([HKObjectType.workoutType(),
 HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
 HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
 HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
 HKObjectType.quantityType(forIdentifier: .heartRate)!])
 
 
 healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
 if !success {
 // Handle the error here.
 }
 }
 */
