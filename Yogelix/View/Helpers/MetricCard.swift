// MetricCardView.swift
import SwiftUI

struct MetricCard: View {
    @State var isRefreshed = false
    @State var title: String
    @State var value: Double
    @State var unit: String
    @State var date: Date?
    @State var emoji: String
    
    var caption: String
    var dateInterval: String?
    var isInteger: Bool = true
    var useTwoDecimalPlaces: Bool = false
    //    var iconName: String  = "circle.badge.checkmark"

    @State private var iconScale: CGFloat = 0.9
    @State private var textOpacity: Double = 0
    @State private var slideInOffset: CGSize = CGSize(width: 20, height: 0)
    
    
    var formattedValue: String {
        return String(format: "%.1f", value)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var formattedDate: String {
        date != nil ? dateFormatter.string(from: date!) : ""
    }
    
    var body: some View {
        
        VStack {
            Text("\(title)")
                .font(.headline)
                .foregroundStyle(.primary)
                .opacity(textOpacity)
                .offset(slideInOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                        textOpacity = 1
                        slideInOffset = .zero
                    }
                }
                .padding()
            
            Text("\(formattedValue) \(unit) \(emoji)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .animation(.bouncy(duration: 2))
                .foregroundColor(Color.blue)
                .padding()
            
            if let dateInterval = dateInterval {
                Text("\(dateInterval)")
                    .font(.subheadline)
                    .foregroundColor(Color.primary)
            } else {
                Text("\(formattedDate)")
                    .font(.subheadline)
                    .foregroundColor(Color.primary)
            }
            
            Text(caption)
                .font(.caption)
                .foregroundColor(.primary)
                .padding(.bottom)
            
        }
        .padding()
        .frame(width: 200, height: 200)
        .background(Color(UIColor.systemFill))
        .cornerRadius(15)
    }
}



struct MetricCard_Preview: PreviewProvider {
    static var previews: some View {
        MetricCard(
            isRefreshed: false, title: "Energy Burn", value: 350.0, unit: "kcal", emoji: "🔥", caption: "Caption"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
