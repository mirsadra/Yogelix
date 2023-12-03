//  HeartRateModel.swift
import Foundation

struct HeartRateModel: Identifiable {
    let id = UUID()
    let date: Date
    let minHeartRate: Double
    let maxHeartRate: Double
    let averageHeartRate: Double
}
