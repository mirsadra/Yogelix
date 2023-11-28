//  SummaryHealth.swift
import Foundation
import SwiftUI

struct SummaryHealth: Identifiable {
    let id: UUID
    var title: String
    var value: Double
    var unit: String
    var caption: String
    var dataDate: DateComponents
    var dateRange: DateRange
    var iconName: String = "figure"
    var isInteger: Bool = true

    enum DateRange {
        case daily
        case weekly(start: Date, end: Date)
        case monthly(start: Date, end: Date)
    }

    var formattedValue: String {
        isInteger ? "\(Int(value))" : String(format: "%.2f", value)
    }

    var formattedDate: String {
        // Formatting the date for display
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        switch dateRange {
            case .daily:
                return formatter.string(from: Calendar.current.date(from: dataDate) ?? Date())
            case .weekly(let start, let end), .monthly(let start, let end):
                return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }
    }

    init(id: UUID = UUID(), title: String, value: Double, unit: String, caption: String, dataDate: DateComponents, dateRange: DateRange, iconName: String, isInteger: Bool) {
        self.id = id
        self.title = title
        self.value = value
        self.unit = unit
        self.caption = caption
        self.dataDate = dataDate
        self.dateRange = dateRange
        self.iconName = iconName
        self.isInteger = isInteger
    }
}



