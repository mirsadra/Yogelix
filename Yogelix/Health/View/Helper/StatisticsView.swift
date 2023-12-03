//  StatisticsView.swift
import SwiftUI

// Struct for a data point
struct BarChartDataPoint {
    var average: Double
    var minimum: Double
    var maximum: Double
    var label: String
}

struct BarChartView: View {
    var dataPoints: [BarChartDataPoint]
    
    // Finds the maximum value to scale the bars
    private var maxValue: Double {
        max(dataPoints.max(by: { $0.maximum < $1.maximum })?.maximum ?? 1, 1)
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(dataPoints.indices, id: \.self) { index in
                VStack {
                    ZStack(alignment: .bottom) {
                        // Base for max value
                        Rectangle()
                            .frame(width: 20, height: 200) // Max bar height
                            .foregroundColor(.clear)

                        // Bar for max value
                        Rectangle()
                            .frame(width: 20, height: calculateHeight(for: dataPoints[index].maximum))
                            .foregroundColor(.red)

                        // Bar for average value
                        Rectangle()
                            .frame(width: 20, height: calculateHeight(for: dataPoints[index].average))
                            .foregroundColor(.blue)

                        // Bar for min value
                        Rectangle()
                            .frame(width: 20, height: calculateHeight(for: dataPoints[index].minimum))
                            .foregroundColor(.green)
                    }
                    Text(dataPoints[index].label)
                        .font(.caption)
                }
            }
        }
    }

    private func calculateHeight(for value: Double) -> CGFloat {
        CGFloat(200 * value / maxValue)
    }
}

struct StatisticsView: View {
    let dataPoints: [BarChartDataPoint] // Populate this with actual data
    
    var body: some View {
        BarChartView(dataPoints: dataPoints)
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(dataPoints: [
            .init(average: 70, minimum: 60, maximum: 80, label: "Mon"),
            .init(average: 72, minimum: 65, maximum: 85, label: "Tue"),
            // Add more for preview
        ])
        .frame(height: 300)
        .padding()
    }
}
