//  CategoryView.swift
import SwiftUI

struct CategoryView: View {
    @StateObject private var viewModel = CategoryDataViewModel()
    @State private var progress: CGFloat = 0.75
    @State private var currentValue = "1800"
    @State private var goalValue = "2000"
    @State private var quantityType = "Calories Burned"
    
    var body: some View {
        VStack {
            Text("Current Day Sleep Analysis")
            List(viewModel.currentDaySleepData, id: \.startDate) { data in
                Text("Sleep from \(data.startDate) to \(data.endDate)")
                    .foregroundStyle(.secondary)
            }
            
            Text("Last Week Sleep Analysis")
            List(viewModel.lastWeekSleepData, id: \.startDate) { data in
                Text("Sleep from \(data.startDate) to \(data.endDate)")
            }
            
            Text("Current Day Mindful Sessions")
            List(viewModel.currentDayMindfulSessionsData, id: \.startDate) { data in
                Text("Mindful Session from \(data.startDate) to \(data.endDate)")
                    .foregroundStyle(.secondary)
            }
            
            Text("Last Week Mindful Sessions")
            List(viewModel.lastWeekMindfulSessionsData, id: \.startDate) { data in
                Text("Mindful Session from \(data.startDate) to \(data.endDate)")
                    .foregroundStyle(.secondary)
            }
            

        }
        .onAppear {
            viewModel.fetchCurrentDaySleepAnalysis { _ in }
            viewModel.fetchLastWeekSleepAnalysis { _ in }
            viewModel.fetchCurrentDayMindfulSessions { _ in }
            viewModel.fetchLastWeekMindfulSessions { _ in }
            
        }
    }
}

#Preview {
    CategoryView()
}
