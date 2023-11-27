//  ProgressRingView.swift
import SwiftUI

struct ProgressRingView: View {
    var progress: Double // Between 0.0 and 1.0
    var thickness: CGFloat = 20.0
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var foregroundColor: Color = Color.blue

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: thickness)
                .fill(backgroundColor)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                .foregroundColor(foregroundColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
        }
    }
}
