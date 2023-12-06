//  DailyChallengeManager.swift
import Foundation

class DailyChallengeManager: ObservableObject {
    @Published var currentChallenge: Pose?
    private var poses: [Pose]
    private let calendar = Calendar.current

    init(poses: [Pose]) {
        self.poses = poses
        loadChallenge()
    }

    func loadChallenge() {
        let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated") as? Date ?? Date.distantPast
        if !calendar.isDateInToday(lastUpdated) {
            selectNewChallenge()
        } else {
            // Load the current challenge from UserDefaults if it exists
            if let savedPoseId = UserDefaults.standard.object(forKey: "currentChallengeId") as? Int {
                self.currentChallenge = poses.first { $0.id == savedPoseId }
            }
        }
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
}
