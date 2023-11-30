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

/*
extension DailyExercise {
    static let sampleExercises: [DailyExercise] = [
        DailyExercise(title: "Warrior III Pose", steps: ["First step: Stand on one leg", "Second step: Extend the other leg backward", "Third step: Reach forward with your arms"], lengthInMin: 20, difficulty: 3, image: "childPoseImage", theme: .sereneGreen),
        DailyExercise(title: "Downward Dog", steps: ["First step: Start on all fours", "Second step: Lift hips up and back", "Third step: Press heels towards the ground"], lengthInMin: 15, difficulty: 2, image: "downwardDogPoseImage", theme: .calmingBlue),
        DailyExercise(title: "Tree Pose", steps: ["First step: Balance on one leg", "Second step: Place the other foot on your inner thigh", "Third step: Bring hands to prayer position"], lengthInMin: 10, difficulty: 2, image: "treePoseImage", theme: .peacefulPurple),
        DailyExercise(title: "Child's Pose", steps: ["First step: Kneel on the floor", "Second step: Touch your big toes together", "Third step: Sit back on your heels and stretch your arms forward"], lengthInMin: 5, difficulty: 1, theme: .meditationMaroon),
        DailyExercise(title: "Cobra Pose", steps: ["First step: Lie face down", "Second step: Place hands under shoulders", "Third step: Lift chest up off the ground"], lengthInMin: 15, difficulty: 2, theme: .zenYellow),
        DailyExercise(title: "Triangle Pose", steps: ["First step: Stand with feet wide apart", "Second step: Turn one foot out and extend arms", "Third step: Bend to the side, touching your foot or shin"], lengthInMin: 20, difficulty: 3, theme: .mindfulnessMint),
        DailyExercise(title: "Seated Forward Bend", steps: ["First step: Sit with legs extended", "Second step: Inhale and lift your arms", "Third step: Exhale and fold forward towards your feet"], lengthInMin: 15, difficulty: 2, theme: .tranquilTeal),
        DailyExercise(title: "Camel Pose", steps: ["First step: Kneel on the floor", "Second step: Place hands on your back or heels", "Third step: Arch back and tilt head backward"], lengthInMin: 20, difficulty: 4, theme: .balanceBeige),
        DailyExercise(title: "Chair Pose", steps: ["First step: Stand with feet together", "Second step: Bend knees as if sitting on a chair", "Third step: Raise arms above your head"], lengthInMin: 10, difficulty: 2, theme: .harmonyGray),
        DailyExercise(title: "Plank Pose", steps: ["First step: Start in push-up position", "Second step: Keep your body straight", "Third step: Hold position with abs engaged"], lengthInMin: 10, difficulty: 3, theme: .energyOrange)
    ]
}
*/
