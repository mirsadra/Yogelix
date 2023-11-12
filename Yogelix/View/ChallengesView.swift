//  ChallengesView.swift
import SwiftUI

struct ChallengesView: View {
    // Placeholder data
    let challenges: [String] = ["30 Day Yoga", "Flexibility Boost", "Mindfulness Master"]

    var body: some View {
        List(challenges, id: \.self) { challenge in
            VStack(alignment: .leading) {
                Text(challenge).font(.headline)
                Text("Details of \(challenge)")
                // You'll add a button or interaction to join the challenge here
            }
        }
        .navigationTitle("Challenges")
    }
}

#Preview {
    ChallengesView()
}
