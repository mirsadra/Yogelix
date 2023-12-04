//  HealthCard.swift
import SwiftUI

struct HealthCard: View {
    
    
    var body: some View {
        ZStack() {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 320, height: 320)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 0.53, green: 0.95, blue: 0.80), Color(red: 0.74, green: 0.75, blue: 0.40), Color(red: 0.37, green: 0.70, blue: 0.57)]), startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(30)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 144, height: 144)
                .background(Color(red: 0, green: 0, blue: 0).opacity(0))
            
            Text("Date: 26 Nov 2023")
                .font(Font.custom("LuckiestGuy", size: 20))
                .lineSpacing(22)
                .foregroundColor(.black)
                .offset(x: 0, y: 76.50)
            Text("Daily Walk + Run")
                .font(Font.custom("LuckiestGuy", size: 21))
                .lineSpacing(22)
                .offset(x: -60.50, y: -79)
            Text("8.43")
                .font(Font.custom("LuckiestGuy", size: 66))
                .lineSpacing(22)
                .offset(x: 0, y: 7)
            Text("km")
                .font(Font.custom("LuckiestGuy", size: 18))
                .lineSpacing(22)
                .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41).opacity(0.54))
                .offset(x: 0, y: 54)
            .frame(width: 42, height: 41)
        }
        .frame(width: 320, height: 320);
    }
}


#Preview {
    HealthCard()
}
