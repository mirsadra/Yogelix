//  MetricCardView.swift
import SwiftUI

struct MetricCardView: View {
    var title: String
    var value: Double
    var unit: String
    var date: Date?
    var isInteger: Bool = true  // default is set to true
    var iconName: String  = "figure" // default is set to figure
    
    var formattedValue: String {
        isInteger ? "\(Int(value))" : String(format: "%.2f", value)
    }
    
    // Formatter for the date
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
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text("\(formattedValue) \(unit)")
                        .font(.title)
                }
            }
    
            if let date = date {
                Text("Date: \(formattedDate)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

