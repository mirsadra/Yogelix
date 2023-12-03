//  SleepAnalysisModel.swift
import Foundation
import HealthKit


struct SleepAnalysisModel {
    var startDate: Date
    var endDate: Date
    // You can add more properties if needed, like duration, type of sleep (inBed, asleep), etc.

    init?(sample: HKSample) {
        guard let categorySample = sample as? HKCategorySample else { return nil }
        self.startDate = categorySample.startDate
        self.endDate = categorySample.endDate
    }
}


