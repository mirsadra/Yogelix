//  WorkoutSummaryCard.swift
import SwiftUI

// Placeholder struct for workout detail data
struct WorkoutDetail {
    var type: String
    var duration: TimeInterval // in seconds
    var totalCaloriesBurned: Double
    var averageHeartRate: Double
}

struct WorkoutSummaryCard: View {
    @EnvironmentObject var quantityViewModel : QuantityDataViewModel
    // Placeholder data
    let workoutDetail = WorkoutDetail(
        type: "Cross Training",
        duration: 3600, // Example for 1 hour
        totalCaloriesBurned: 500,
        averageHeartRate: 120
    )
    
    // Helper to format the duration from seconds to a human-readable string
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(workoutDetail.type)
                .font(.headline)

            HStack {
                Image(systemName: "flame.fill") // Example system image
                    .foregroundColor(.orange)
                Text("\(Int(workoutDetail.totalCaloriesBurned)) Calories")
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "heart.fill") // Example system image
                    .foregroundColor(.red)
                Text("\(Int(workoutDetail.averageHeartRate)) BPM Average")
                    .font(.subheadline)
            }

            HStack {
                Image(systemName: "clock.fill") // Example system image
                    .foregroundColor(.blue)
                Text(formatDuration(workoutDetail.duration))
                    .font(.subheadline)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 5))
    }
}

// Preview in Xcode
struct WorkoutSummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSummaryCard()

            .previewLayout(.sizeThatFits)
            .padding()
    }
}
