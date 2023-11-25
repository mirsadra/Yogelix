//  ActivityRingView.swift
import SwiftUI
import HealthKitUI

struct ActivityRingView: UIViewRepresentable {
    var activitySummary: HKActivitySummary

    func makeUIView(context: Context) -> HKActivityRingView {
        return HKActivityRingView()
    }

    func updateUIView(_ uiView: HKActivityRingView, context: Context) {
        uiView.setActivitySummary(activitySummary, animated: true)
    }
}
