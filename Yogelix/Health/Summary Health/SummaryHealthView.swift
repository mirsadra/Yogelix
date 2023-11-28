//  SummaryHealthView.swift
import SwiftUI
import Foundation
import HealthKit

struct SummaryHealthView: View {
    @ObservedObject var viewModel = HealthDataViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.summaryHealthItems) { item in
                SummaryCardView(summaryHealth: item)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchAllData() // This should eventually trigger processHealthData
        }
    }
}

struct SummaryHealthView_Previews: PreviewProvider {
    static var previews: some View {
        // Create mock HealthDataViewModel
        let mockViewModel = HealthDataViewModel()
        
        // Mock data for preview
        let sampleSummaryHealthItems = [
            SummaryHealth(
                title: "Heart Rate",
                value: 72.0,
                unit: "BPM",
                caption: "Average over the week",
                dataDate: DateComponents(year: 2023, month: 1, day: 1),
                dateRange: .weekly(start: Date(), end: Date()),
                iconName: "heart.fill",
                isInteger: false
            ),
            // Add more sample SummaryHealth instances here
        ]

        // Assign mock data to viewModel's summaryHealthItems
        mockViewModel.summaryHealthItems = sampleSummaryHealthItems

        // Return the view for preview with the mock ViewModel
        return SummaryHealthView(viewModel: mockViewModel)
    }
}
