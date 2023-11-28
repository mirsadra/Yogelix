//  SummaryCardView.swift
import SwiftUI

struct SummaryCardView: View {
    var summaryHealth: SummaryHealth

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: summaryHealth.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text(summaryHealth.title)
                        .font(.headline)
                    Text(summaryHealth.formattedValue + " " + summaryHealth.unit)
                        .font(.title)
                }
            }

            Text("Date: " + summaryHealth.formattedDate)
                .font(.subheadline)
            Text(summaryHealth.caption)
                .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct SummaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample SummaryHealth instance for the preview
        let sampleSummaryHealth = SummaryHealth(
            title: "Heart Rate",
            value: 72.0,
            unit: "BPM",
            caption: "Average over the week",
            dataDate: DateComponents(year: 2023, month: 11, day: 28),
            dateRange: .weekly(start: Date(), end: Date()),
            iconName: "heart.fill",
            isInteger: false
        )

        // Use the sample data to preview the SummaryCardView
        SummaryCardView(summaryHealth: sampleSummaryHealth)
            .previewLayout(.sizeThatFits)
    }
}
