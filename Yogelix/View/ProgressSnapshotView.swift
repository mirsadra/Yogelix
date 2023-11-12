//  ProgressSnapshotView.swift
import SwiftUI

struct ProgressSnapshotView: View {
    // Mockup data
    let sessionsCompleted = 26
    let totalYogaHours = 40
    let currentStreak = 5 // days

    var body: some View {
        HStack(spacing: 20) {
            StatView(statName: "Sessions", statValue: "\(sessionsCompleted)")
            StatView(statName: "Hours", statValue: "\(totalYogaHours)")
            StatView(statName: "Streak", statValue: "\(currentStreak) days")
        }
        .padding()
    }
}

struct StatView: View {
    var statName: String
    var statValue: String
    
    var body: some View {
        VStack {
            Text(statValue)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(statName)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProgressSnapshotView()
}
