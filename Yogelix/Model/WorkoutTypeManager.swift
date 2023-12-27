// WorkoutTypeManager.swift
import Foundation
import HealthKit

class WorkoutTypeManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Authorization Request: Read and Write
    private func healthDataTypes() -> (read: Set<HKObjectType>, write: Set<HKSampleType>) {
        let workoutType = HKObjectType.workoutType()  // Directly used, as it's non-optional
        
        let readTypes: Set<HKObjectType> = [workoutType]
        let writeTypes: Set<HKSampleType> = [workoutType]
        
        return (readTypes, writeTypes)
    }
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, CustomError?) -> Void) {
        let (readTypes, writeTypes) = healthDataTypes()
        
        // Request Authorization
        func performRequest() {
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
                if success {
                    completion(true, nil)
                } else {
                    completion(false, .authorizationFailed)
                }
            }
        }
        
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: performRequest)
        } else {
            performRequest()
        }
    }
    
    // MARK: - Authorization Check Methods
    func isAuthorizedForWorkouts() -> Bool {
        return healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized
    }
    
    
    // MARK: - Write (save) Yoga Workout into Health app from Yogelix.
    func saveYogaWorkout(startDate: Date, endDate: Date, activeEnergyBurned: Double?, appleExerciseTime: Double?, completion: @escaping (HKWorkout?, CustomError?) -> Void) {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .yoga
        workoutConfiguration.locationType = .unknown
        
        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration, device: HKDevice.local())
        builder.beginCollection(withStart: startDate) { success, error in
            guard success else {
                completion(nil, CustomError.workoutSaveFailed)
                return
            }
            
            var samples = [HKSample]()
            
            if let activeEnergyValue = activeEnergyBurned {
                let activeEnergyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: activeEnergyValue)
                let activeEnergySample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!, quantity: activeEnergyQuantity, start: startDate, end: endDate)
                samples.append(activeEnergySample)
            }
            
            if let exerciseTimeValue = appleExerciseTime {
                let exerciseTimeQuantity = HKQuantity(unit: HKUnit.minute(), doubleValue: exerciseTimeValue)
                let exerciseTimeSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!, quantity: exerciseTimeQuantity, start: startDate, end: endDate)
                samples.append(exerciseTimeSample)
            }
            
            builder.add(samples) { success, error in
                guard success else {
                    completion(nil, CustomError.workoutSaveBuildFailed)
                    return
                }
                
                builder.endCollection(withEnd: endDate) { success, error in
                    guard success else {
                        completion(nil, CustomError.workoutSaveBuildFailed)
                        return
                    }
                    
                    builder.finishWorkout { workout, error in
                        if let workout = workout {
                            completion(workout, nil) // Successfully saved the workout
                        } else if let error = error {
                            print("Error saving workout: \(error.localizedDescription)")
                            completion(nil, .workoutSaveFailed) // There was an error saving the workout
                        } else {
                            completion(nil, CustomError.workoutSaveBuildFailed) // Generic error
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Reading Yoga Workouts
    func readYogaWorkouts(completion: @escaping ([HKWorkout]?, CustomError?) -> Void) {
        // 1. Define the workout type
        let workoutType = HKObjectType.workoutType()
        // 2. Create a predicate to filter the workouts
        let predicate = HKQuery.predicateForWorkouts(with: .yoga)
        // 3. Create a query
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            if error != nil {
                completion(nil, .workoutReadFailed)
                return
            }
            
            guard let workouts = samples as? [HKWorkout] else {
                completion(nil, .workoutReadFailed)
                return
            }
            
            completion(workouts, nil)
        }
        
        // 4. Execute the query
        healthStore.execute(query)
    }
    
    // MARK: - Custom Error Handling
    enum CustomError: Error, Identifiable {
        case authorizationFailed
        case workoutSaveFailed
        case workoutSaveBuildFailed
        case workoutReadFailed

        var id: Int {
            switch self {
            case .authorizationFailed:
                return 1
            case .workoutSaveFailed:
                return 2
            case .workoutSaveBuildFailed:
                return 3
            case .workoutReadFailed:
                return 4
            }
        }
        
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
