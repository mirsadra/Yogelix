//  DailyExercise.swift
import Foundation
import SwiftUI

struct DailyPractice: Identifiable {
    let id: UUID
    var title: String
    var goal: String
    var duration: String  // short, medidum, lengthy
    var difficulty: Int   // easy, intermediate, hard
    var image: String
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, goal: String, duration: String, difficulty: Int, image: String, theme: Theme) {
        self.id = id
        self.title = title
        self.goal = goal
        self.duration = duration
        self.difficulty = difficulty
        self.image = image
        self.theme = theme
    }
}


extension DailyPractice {
    static let dailyPractices: [DailyPractice] = [
        DailyPractice(title: "Regular Practice", goal: "Consistency", duration: "Short", difficulty: 3, image: "childPoseImage", theme: .sereneGreen)
    ]
}

