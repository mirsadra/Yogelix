// MetricCardView.swift
import SwiftUI

struct MetricCardView: View {
    var title: String
    var value: Double
    var unit: String
    var date: Date?
    var caption: String
    var dateInterval: String?
    var isInteger: Bool = true
    var useTwoDecimalPlaces: Bool = false
    var iconName: String  = "circle.badge.checkmark"
    
    @State private var iconScale: CGFloat = 0.9
    @State private var textOpacity: Double = 0
    @State private var slideInOffset: CGSize = CGSize(width: 20, height: 0)
    
    
    var formattedValue: String {
        if useTwoDecimalPlaces {
            return String(format: "%.2f", value)
        } else {
            return isInteger ? "\(Int(value))" : String(format: "%.2f", value)
        }
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
            Label("\(title)", systemImage: "\(iconName)")
                .font(.headline)
                .foregroundStyle(.black, .mint)
                .padding(.top)
                .scaleEffect(iconScale)
                .symbolRenderingMode(.multicolor)
                .opacity(textOpacity)
                .offset(slideInOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                        textOpacity = 1
                        slideInOffset = .zero
                    }
                }
            
            Text("\(formattedValue) \(unit)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.vertical, 2)
            
            if let dateInterval = dateInterval {
                Text("Period: \(dateInterval)")
                    .font(.subheadline)
                    .foregroundColor(Color.accentColor)
            } else if let date = date {
                Text("Date: \(formattedDate)")
                    .font(.subheadline)
                    .foregroundColor(Color.accentColor)
            }
            
            Text(caption)
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(.bottom)
            // New VStack with Picker and Button
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 10, y: 10)
    }
    
}
