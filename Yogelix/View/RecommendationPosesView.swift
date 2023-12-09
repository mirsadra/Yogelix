// RecommendationPosesView.swift
import SwiftUI

struct RecommendationPosesView: View {
    var recommendationCategory: RecommendedForCategory
    var poses: [Pose]

    var body: some View {
        List(poses, id: \.id) { pose in
            Text(pose.englishName)
        }
        .navigationTitle(recommendationCategory.rawValue)
    }
}

// Define enum for RecommendedFor categories
enum RecommendedForCategory: String, CaseIterable {
    case lowHeartRate = "Low Heart Rate"
    case highEnergyBurn = "High Energy Burn"
    case longExerciseDuration = "Long Exercise Duration"
    // Add other categories as needed
}
