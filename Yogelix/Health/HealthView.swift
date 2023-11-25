//  HealthView.swift
import SwiftUI
import Charts
import HealthKit

struct HealthView: View {
    @StateObject private var viewModel = HealthDataViewModel() // Use StateObject for view model

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ActivityRingView(activitySummary: viewModel.activitySummary) // Bind to viewModel
                    .frame(width: 100, height: 100)
                    .onAppear {
                        viewModel.loadActivitySummary() // Call method on viewModel
                    }
                    .navigationBarTitle("Dashboard", displayMode: .inline)
            }
        }
    }
}


struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}
