//  GoalsSectionView.swift
import SwiftUI

// Placeholder struct for goal data
struct GoalData {
    var title: String
    var value: String
    var progress: CGFloat // normalized value between 0 and 1
    var color: Color
}

struct GoalProgressView: View {
    var data: GoalData
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(data.color)
            
            Circle()
                .trim(from: 0, to: data.progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(data.color)
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear)
            
            VStack {
                Text(data.title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(data.value)
                    .font(.headline)
                    .foregroundColor(data.color)
            }
        }
    }
}

struct GoalsSectionView: View {
    // Placeholder goals data
    let goalsData: [GoalData] = [
        GoalData(title: "Calories", value: "400 kcal", progress: 0.5, color: .red),
        GoalData(title: "Exercise", value: "30 min", progress: 0.75, color: .green),
        GoalData(title: "Stand", value: "12 hr", progress: 1.0, color: .blue)
    ]
    
    var body: some View {
        HStack {
            ForEach(goalsData, id: \.title) { goalData in
                GoalProgressView(data: goalData)
                    .frame(width: 100, height: 100)
            }
        }
    }
}

// Preview in Xcode
struct GoalsSectionView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsSectionView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
