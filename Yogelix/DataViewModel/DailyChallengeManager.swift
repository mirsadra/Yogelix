//  DailyChallengeManager.swift
import Foundation

// ObservableObject allows the class to to publish certain properties.
class DailyChallengeManager: ObservableObject {
    @Published var currentChallenge: Pose?
    private var poses: [Pose]
    private let calendar = Calendar.current
    private let userData: UserData  // Reference to UserData to update achievements
    private var poseViewModel: PoseViewModel

    init(poses: [Pose], userData: UserData, poseViewModel: PoseViewModel) {  // Modify this
        self.poses = poses
        self.userData = userData
        self.poseViewModel = poseViewModel  // Add this
        loadChallenge()
    }

    func loadChallenge() {
        let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated") as? Date ?? Date.distantPast
        if !calendar.isDateInToday(lastUpdated) {
            selectNewChallenge()
        } else {
            if let savedPoseId = UserDefaults.standard.object(forKey: "currentChallengeId") as? Int {
                self.currentChallenge = poses.first { $0.id == savedPoseId }
            }
        }
        poseViewModel.currentPoseOfTheDay = currentChallenge
    }

    private func selectNewChallenge() {
        currentChallenge = poses.randomElement()
        saveChallenge()
    }


    private func saveChallenge() {
        if let challengeId = currentChallenge?.id {
            UserDefaults.standard.set(challengeId, forKey: "currentChallengeId")
            UserDefaults.standard.set(Date(), forKey: "lastUpdated")
        }
    }

    // Call this method when the user completes the daily challenge
    func completeChallenge(duration: Int) {
        guard let pose = currentChallenge else { return }

        let trophy = determineTrophy(for: pose, duration: duration)
        userData.updateAchievement(for: pose, with: trophy)
    }


    // Determines the type of trophy based on pose difficulty and duration
    private func determineTrophy(for pose: Pose, duration: Int) -> TrophyType {
        switch pose.difficulty {
        case 1: // Easier poses
            if duration > 90 { return .gold }
            else if duration > 60 { return .silver }
            else { return .bronze }
        case 2: // Intermediate poses
            if duration > 120 { return .gold }
            else if duration > 90 { return .silver }
            else { return .bronze }
        case 3: // Harder poses
            if duration > 150 { return .gold }
            else if duration > 120 { return .silver }
            else { return .bronze }
        default:
            return .bronze
        }
    }
}

enum TrophyType: String {
    case gold, silver, bronze
}
