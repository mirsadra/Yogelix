//  SleepAnalysisModel.swift
import Foundation
import HealthKit
import CoreData

struct SleepAnalysisModel {
    var startDate: Date
    var endDate: Date
    var duration: TimeInterval // Duration in seconds
    var asleepDeep: TimeInterval // Duration of deep sleep in seconds
    var identifier: String // A unique identifier for the data
    var source: String // The source of the data, e.g., "HealthKit"
    // Additional attributes as needed

    init?(sample: HKSample, deepSleepData: TimeInterval?) {
        guard let categorySample = sample as? HKCategorySample else { return nil }
        self.startDate = categorySample.startDate
        self.endDate = categorySample.endDate
        self.duration = endDate.timeIntervalSince(startDate)
        self.asleepDeep = deepSleepData ?? 0 // Default to 0 if not provided
        self.identifier = UUID().uuidString // Generate a new UUID for each instance
        self.source = "HealthKit" // Set the source as HealthKit
    }
}

