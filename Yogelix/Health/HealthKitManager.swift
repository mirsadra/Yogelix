//  HealthKitManager.swift
import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Safely unwrap HKSampleType and HKCharacteristicType
        guard let bodyMassType = HKObjectType.quantityType(forIdentifier: .bodyMass),
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
            bodyMassType,
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
        
        // Specify only the types you need to write
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, NSError(domain: "HealthKit", code: 101, userInfo: [NSLocalizedDescriptionKey: "Unable to create heart rate type"]))
            return
        }
        guard let activeEnergyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(false, NSError(domain: "HealthKit", code: 102, userInfo: [NSLocalizedDescriptionKey: "Unable to create active energy burned type"]))
            return
        }
        
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
        guard let bodyMassType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
            completion(nil, NSError(domain: "HealthKit", code: 200, userInfo: [NSLocalizedDescriptionKey: "Body Mass type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: bodyMassType, predicate: mostRecentPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples?.first as? HKQuantitySample, error)
        }
        
        healthStore.execute(query)
    }
    
    // Read heart rate
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
    
    // Read height
    func readHeight(completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        guard let heightType = HKSampleType.quantityType(forIdentifier: .height) else {
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
    
    // Read sleep analysis
    func readSleepAnalysis(completion: @escaping ([HKCategorySample]?, Error?) -> Void) {
        guard let sleepAnalysisType = HKSampleType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthKit", code: 203, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type is not available"]))
            return
        }
        
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sleepAnalysisType, predicate: mostRecentPredicate, limit: 10, sortDescriptors: [sortDescriptor]) { _, samples, error in
            completion(samples as? [HKCategorySample], error)
        }
        
        healthStore.execute(query)
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

