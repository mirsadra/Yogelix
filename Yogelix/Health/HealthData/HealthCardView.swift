//  HealthCardView.swift
import SwiftUI

struct HealthCardView: View {
    var title: String
    var value: Double
    var unit: String
    var progress: CGFloat
    var progressColor: Color
    var backgroundColor: Color

    var body: some View {
        VStack {
            HeaderView()
            
            GeometryReader { geometry in
                ProgressView(geometry: geometry)
            }
            .frame(height: 60)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12.0)
        .shadow(radius: 5)
    }

    private func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(value, specifier: "%.0f") \(unit)")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            Spacer()
            
            Image(systemName: "carrot")
                .resizable()
                .frame(width: 28, height: 28)
        }
    }

    private func ProgressView(geometry: GeometryProxy) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10.0)
                .frame(width: geometry.size.width, height: 20)
                .opacity(0.3)
                .foregroundColor(Color(UIColor.systemTeal))

            RoundedRectangle(cornerRadius: 10.0)
                .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width), height: 20)
                .foregroundColor(progressColor)
                .animation(.linear, value: progress)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    HealthCardView(title: "Active Calories", value: 1145.0, unit: "kcal", progress: 0.5, progressColor: .red, backgroundColor: .white)
}
