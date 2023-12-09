// TrophyView to visually represent the trophy and progress
import SwiftUI

struct TrophyView: View {
    var progress: Double
    var trophy: TrophyType
    var color: Color

    var body: some View {
        VStack {
            // Image representing the trophy - replace with actual image resource names
            Image(systemName: trophyImageName(trophy))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(color)

            // Progress Bar
            ProgressView(value: progress, total: 1.0)
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(width: 100)

            // Progress in percentage
            Text("\(Int(progress * 100))%")
                .font(.caption)
        }
        .padding()
    }

    private func trophyImageName(_ trophy: TrophyType) -> String {
        // Replace with your actual image resource names
        switch trophy {
        case .gold:
            return "star.fill" // Example system image for gold
        case .silver:
            return "star.lefthalf.fill" // Example system image for silver
        case .bronze:
            return "star" // Example system image for bronze
        }
    }
}
