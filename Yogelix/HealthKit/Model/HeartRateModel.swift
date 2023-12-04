//  HeartRateModel.swift
import Foundation
import HealthKit
import CoreData

struct HeartRateModel {
    var identifier: String
    var startDate: Date
    var endDate: Date
    var duration: TimeInterval
    var minHeartRate: Double
    var maxHeartRate: Double
    var averageHeartRate: Double
    var source: String
    
}


