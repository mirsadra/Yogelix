//  ActivityRingView.swift
import SwiftUI

struct ActivityRingsView: View {
    // Placeholder progress values
    // In a real scenario, these would be @Binding properties tied to your ViewModel
    let moveProgress: CGFloat = 0.7
    let exerciseProgress: CGFloat = 0.5
    let standProgress: CGFloat = 0.4

    var body: some View {
        ZStack {
            RingView(progress: moveProgress, startColor: .red, endColor: .orange, ringWidth: 15)
                .animation(.default)
            RingView(progress: exerciseProgress, startColor: .green, endColor: .yellow, ringWidth: 10)
                .padding(20) // Creates space between the rings
                .animation(.default)
            RingView(progress: standProgress, startColor: .blue, endColor: .purple, ringWidth: 5)
                .padding(40) // Creates space between the rings
                .animation(.default)
        }
    }
}

#Preview {
    ActivityRingsView()
}
