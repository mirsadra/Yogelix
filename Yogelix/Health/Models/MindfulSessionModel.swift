//  MindfulSessionModel.swift
import Foundation
import HealthKit

struct MindfulSessionModel {
    var startDate: Date
    var endDate: Date
    // Additional properties can be added as per your application's requirements.

    init?(sample: HKSample) {
        guard let categorySample = sample as? HKCategorySample else { return nil }
        self.startDate = categorySample.startDate
        self.endDate = categorySample.endDate
    }
}

