// MetricCardView.swift
import SwiftUI

struct MetricCard: View {
    var title: String
    var emoji: String
    var value: Double
    var unit: String
    var date: Date?
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
                .foregroundStyle(.harmonyGray)
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
                .fontWeight(.bold)
                .animation(.bouncy(duration: 2))
                .foregroundColor(Color.orange)
                .padding()
            
            if let dateInterval = dateInterval {
                Text("\(dateInterval)")
                    .font(.subheadline)
                    .foregroundColor(Color.primary)
            } else {
                Text("\(formattedDate)")
                    .font(.subheadline)
                    .foregroundColor(Color.harmonyGray)
            }
            
            Text(caption)
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(.bottom)
            // New VStack with Picker and Button
            
        }
        .padding()
        .frame(width: 200, height: 200) 
        .background(.primary)
        .cornerRadius(15)
        .shadow(color: Color.sereneGreen.opacity(0.4), radius: 10, x: 8, y: 5)
    }
}



struct MetricCard_Preview: PreviewProvider {
    static var previews: some View {
        MetricCard(
            title: "Energy Burn",
            emoji: "🔥",
            value: 350.0,
            unit: "kcal",
            date: Date(),
            caption: "Total Sum of the Day",
            dateInterval: nil,
            isInteger: false,
            useTwoDecimalPlaces: true
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
