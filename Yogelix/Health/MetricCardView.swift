import SwiftUI

struct MetricCardView: View {
    var title: String
    var value: Double
    var unit: String
    var date: Date?
    var caption: String
    var dateInterval: String?
    var isInteger: Bool = true
    var iconName: String  = "figure"

    @State private var iconScale: CGFloat = 0.9
    @State private var textOpacity: Double = 0
    @State private var slideInOffset: CGSize = CGSize(width: 20, height: 0)

    var formattedValue: String {
        isInteger ? "\(Int(value))" : String(format: "%.2f", value)
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
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.blue)
                .padding(.top)
                .scaleEffect(iconScale)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.6)) {
                        iconScale = 1.0
                    }
                }

            Text(title)
                .font(.headline)
                .foregroundColor(Color.gray)
                .opacity(textOpacity)
                .offset(slideInOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                        textOpacity = 1
                        slideInOffset = .zero
                    }
                }

            Text("\(formattedValue) \(unit)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.vertical, 2)

            if let dateInterval = dateInterval {
                Text("Period: \(dateInterval)")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            } else if let date = date {
                Text("Date: \(formattedDate)")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
            }

            Text(caption)
                .font(.caption)
                .foregroundColor(Color.gray)
                .padding(.bottom)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.4), radius: 10, x: 0, y: 4)
    }
}
