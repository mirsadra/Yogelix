//  HealthKitManager.swift
import HealthKit
import UserNotifications

class HealthKitManager {
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(false)
            return
        }

        let dataTypesToReadAndWrite = Set([heartRateType, stepsType, distanceType])

        healthStore.requestAuthorization(toShare: dataTypesToReadAndWrite, read: dataTypesToReadAndWrite) { success, error in
            completion(success)
        }
    }
    
    // Fetch Heart Rate
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
    
    // Fetch step count data
    func fetchStepsData(completion: @escaping ([StepsData]) -> Void) {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion([])
            return
        }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        let query = HKSampleQuery(sampleType: stepsType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKQuantitySample] else {
                completion([])
                return
            }

            let stepsData = samples.map { sample -> StepsData in
                let steps = sample.quantity.doubleValue(for: HKUnit.count())
                return StepsData(value: steps, date: sample.endDate)
            }

            DispatchQueue.main.async {
                completion(stepsData)
            }
        }

        healthStore.execute(query)
    }
    
    // Fetch Distance data
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
