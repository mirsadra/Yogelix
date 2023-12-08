//  HealthCard.swift
import SwiftUI

struct HealthCard: View {
    @State var isRefreshed = false
    @State var title = "Daily Week + Run"
    @State var value: Double = 8.43
    @State var unit: String = "km"
    @State var date: Date?
    @State var emoji: String = "😍"
    
    var formattedValue: String { return String(format: "%.2f", value) }
    
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
        ZStack() {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 177.48, height: 177.48)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.53, green: 0.95, blue: 0.80), Color(red: 0.74, green: 0.75, blue: 0.40), Color(red: 0.37, green: 0.70, blue: 0.57)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(25)
            
            VStack{
                Text("\(title)")
                    .font(Font.custom("Luckiest Guy", size: 14))
                    .foregroundStyle(.calmingBlue)
                    .padding(.top)
                
                Spacer()
                
                Text("\(formattedValue)")
                    .font(Font.custom("Luckiest Guy", size: 33))
                   
                
                Text("\(unit)")
                    .font(Font.custom("Luckiest Guy", size: 13))
                    .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41).opacity(0.54))
                
                Text("\(emoji)")
                    .font(.caption)
                
                Spacer()
                
                Text("\(formattedDate)")
                    .font(Font.custom("Luckiest Guy", size: 14))
                    .foregroundStyle(.calmingBlue)
                
                Button(
                    action: {
                        isRefreshed.toggle()
                    },
                    label: {
                        Image(systemName: "arrow.clockwise.circle")
                            .foregroundStyle(.calmingBlue)
                            .rotationEffect(.degrees(isRefreshed ? 360 : 0))
                            .padding(.bottom)
                    }
                )

                    
            }
            
        }
        .frame(width: 160, height: 160)
    }
}


#Preview {
    HealthCard()
        .previewLayout(.fixed(width: 160, height: 160))
}
