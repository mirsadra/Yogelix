//  TrophyView.swift
import SwiftUI

struct TrophyView: View {
    var progress: Double
    var activityName: String
    var color: Color

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 10)
                    .frame(width: 150, height: 150)

                Circle()
                    .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                    .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.bouncy, value: 2)
            }

            Text("\(Int(progress * 100))%")
                .font(.title)
                .foregroundColor(color)

            Text(activityName)
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

#Preview {
    TrophyView(progress: 0.8, activityName: "Cow Pose", color: .accentColor)
}
