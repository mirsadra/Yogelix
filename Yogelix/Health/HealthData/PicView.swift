//  PicView.swift
import SwiftUI

struct PicView: View {
    var title: String
    var value: Double
    var unit: String
    var progress: CGFloat
    var progressColor: Color
    var backgroundColor: Color

    var body: some View {
        HStack {
            HealthCardView(title: title, value: value, unit: unit, progress: progress, progressColor: progressColor, backgroundColor: backgroundColor)
            HealthCardView(title: title, value: value, unit: unit, progress: progress, progressColor: progressColor, backgroundColor: backgroundColor)
        }
        .padding()
    }
}

struct PicView_Previews: PreviewProvider {
    static var previews: some View {
        PicView(title: "Active Calories", value: 1145, unit: "kcal", progress: 0.5, progressColor: .red, backgroundColor: .white)
    }
}
