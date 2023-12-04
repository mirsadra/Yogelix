//  CategoryTypeManager.swift
import Foundation
import HealthKit
import CoreData

class CategoryTypeManager {
    private let healthStore = HKHealthStore()
    
    // MARK: - Authorization Request: Read
    private func categoryDataTypes() -> (read: Set<HKObjectType>, error: Error?) {
        guard let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
              let mindfulSessionType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            let error = NSError(domain: "HealthKit", code: 2000, userInfo: [NSLocalizedDescriptionKey: "Unable to create category data types"])
            return(Set(), error)
        }
        let readTypes: Set<HKObjectType> = [
            sleepAnalysisType,
            mindfulSessionType
        ]
        
        return(readTypes, nil)
    }
    
    // MARK: - Request permission from the user
    func requestAuthorization(completion: @escaping (Bool, CustomError?) -> Void) {
        let (readTypes, _) = categoryDataTypes()
        
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
    func isAuthorizedForSleepAnalysis() -> Bool {
        guard let sleepAnalysisType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            return false
        }
        return healthStore.authorizationStatus(for: sleepAnalysisType) == .sharingAuthorized
    }
    
    func isAuthorizedForMindfulSession() -> Bool {
        guard let mindfullSessionType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            return false
        }
        return healthStore.authorizationStatus(for: mindfullSessionType) == .sharingAuthorized
    }
    
    // MARK: Reading
    func readCurrentDaySleepAnalysis(completion: @escaping ([SleepAnalysisModel]?, Error?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthKit", code: 2001, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type is not available"]))
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }
            let sleepData = samples?.compactMap { sample -> SleepAnalysisModel? in
                // Assuming deep sleep data is not available and setting it to nil
                return SleepAnalysisModel(sample: sample, deepSleepData: nil)
            }
            completion(sleepData, nil)
            
        }
        healthStore.execute(query)
    }
    
    func readLastWeekSleepAnalysis(completion: @escaping ([SleepAnalysisModel]?, Error?) -> Void) {
        guard let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil, NSError(domain: "HealthKit", code: 2002, userInfo: [NSLocalizedDescriptionKey: "Sleep Analysis type is not available"]))
            return
        }
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: Date()) else {
            completion(nil, NSError(domain: "HealthKit", code: 2003, userInfo: [NSLocalizedDescriptionKey: "Cannot calculate start date"]))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }
            let sleepData = samples?.compactMap { sample -> SleepAnalysisModel? in
                // Assuming deep sleep data is not available and setting it to nil
                return SleepAnalysisModel(sample: sample, deepSleepData: nil)
            }
            completion(sleepData, nil)
            
        }
        healthStore.execute(query)
    }
    
    func readCurrentDayMindfulSessions(completion: @escaping ([MindfulSessionModel]?, Error?) -> Void) {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            completion(nil, NSError(domain: "HealthKit", code: 2004, userInfo: [NSLocalizedDescriptionKey: "Mindful Session type is not available"]))
            return
        }
        
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }
            let mindfulSessionData = samples?.compactMap(MindfulSessionModel.init)
            completion(mindfulSessionData, nil)
        }
        healthStore.execute(query)
    }
    
    func readLastWeekMindfulSessions(completion: @escaping ([MindfulSessionModel]?, Error?) -> Void) {
        guard let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession) else {
            completion(nil, NSError(domain: "HealthKit", code: 2005, userInfo: [NSLocalizedDescriptionKey: "Mindful Session type is not available"]))
            return
        }
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: Date()) else {
            completion(nil, NSError(domain: "HealthKit", code: 2006, userInfo: [NSLocalizedDescriptionKey: "Cannot calculate start date"]))
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: mindfulType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
            if let error = error {
                completion(nil, error)
                return
            }
            let mindfulSessionAnalysisData = samples?.compactMap(MindfulSessionModel.init)
            completion(mindfulSessionAnalysisData, nil)
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
