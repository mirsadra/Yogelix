//  DailyExercise.swift
import Foundation
import SwiftUI

struct DailyExercise: Identifiable, Hashable {
    var id = UUID()
    var pose: Pose
    var durationInMinutes: Int
    var date: Date
    var isCompleted: Bool
}
