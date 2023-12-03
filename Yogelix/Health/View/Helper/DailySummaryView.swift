//  DailySummaryView.swift
import SwiftUI

// Placeholder struct for daily metrics data
struct DailyMetric {
    var title: String
    var value: String
    var unit: String
}

struct DailyMetricsListView: View {
    var metrics: [DailyMetric]
    
    var body: some View {
        ForEach(metrics, id: \.title) { metric in
            HStack {
                VStack(alignment: .leading) {
                    Text(metric.title)
                        .font(.headline)
                    Text(metric.value)
                        .font(.body)
                }
                Spacer()
                Text(metric.unit)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            Divider()
        }
    }
}

struct DailySummaryView: View {
    // Placeholder daily metrics data
    let dailyMetrics: [DailyMetric] = [
        DailyMetric(title: "Sleep", value: "8h 30m", unit: "hr"),
        DailyMetric(title: "Active Calories", value: "580", unit: "kcal"),
        DailyMetric(title: "Exercise", value: "45", unit: "min"),
        DailyMetric(title: "Stand Hours", value: "12", unit: "hr"),
        DailyMetric(title: "Heart Rate", value: "76", unit: "bpm")
    ]
    
    var body: some View {
        ScrollView {
            DailyMetricsListView(metrics: dailyMetrics)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// Preview in Xcode
struct DailySummaryView_Previews: PreviewProvider {
    static var previews: some View {
        DailySummaryView()
    }
}
