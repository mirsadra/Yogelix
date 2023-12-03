//  WidgetsView.swift
import SwiftUI

// Placeholder struct for widget data
struct WidgetData {
    var title: String
    var value: String
    var color: Color
}

struct SummaryCardView: View {
    var data: WidgetData
    
    var body: some View {
        VStack {
            Text(data.title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(data.value)
                .font(.headline)
                .foregroundColor(data.color)
        }
        .padding()
        .frame(width: 100, height: 100)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 5))
    }
}

struct WidgetsView: View {
    // Placeholder widget data
    let widgets: [WidgetData] = [
        WidgetData(title: "Calories", value: "1,400 kcal", color: .red),
        WidgetData(title: "Exercise", value: "30 min", color: .green),
        WidgetData(title: "Stand", value: "10/12 hr", color: .blue),
        WidgetData(title: "Heart Rate", value: "120 bpm", color: .pink)
    ]
    
    // Define the grid layout
    let gridLayout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: gridLayout, spacing: 20) {
            ForEach(widgets, id: \.title) { widget in
                SummaryCardView(data: widget)
            }
        }
        .padding()
    }
}

// Preview in Xcode
struct WidgetsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsView()
            .previewLayout(.sizeThatFits)
    }
}
