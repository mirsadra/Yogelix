// ChakraDetailView.swift
import SwiftUI

struct ChakraDetailView: View {
    var chakraDetail: ChakraDetail

    var body: some View {
        
        VStack(alignment: .leading) {
            Text(chakraDetail.name.rawValue)
                .font(.custom("LuckiestGuy-Regular", size: 20))
            
            // Element
            HStack(spacing: 0) {
                Text("Element: ")
                    .foregroundColor(Color.blue) // Change label color here
                Text("\(chakraDetail.element)")
            }
            .font(.custom("LuckiestGuy-Regular", size: 16))

            // Location
            HStack(spacing: 0) {
                Text("Location: ")
                    .foregroundColor(Color.red) // Change label color here
                Text("\(chakraDetail.location)")
            }
            .font(.custom("LuckiestGuy-Regular", size: 16))

            // Number of Petals
            HStack(spacing: 0) {
                Text("Number of Petals: ")
                    .foregroundColor(Color.green) // Change label color here
                Text("\(chakraDetail.numberOfPetals)")
            }
            .font(.custom("LuckiestGuy-Regular", size: 16))

            // Focus
            HStack(spacing: 0) {
                Text("Focus: ")
                    .foregroundColor(Color.purple) // Change label color here
                Text("\(chakraDetail.formattedFocus)")
            }
            .font(.custom("LuckiestGuy-Regular", size: 16))

            // Color
            HStack(spacing: 0) {
                Text("Color: ")
                    .foregroundColor(Color.orange) // Change label color here
                Text("\(chakraDetail.color)")
            }
            .font(.custom("LuckiestGuy-Regular", size: 16))
        }
        .padding()
        .frame(width: 310, height: 160)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.53, green: 0.95, blue: 0.80), Color(red: 0.74, green: 0.75, blue: 0.40), Color(red: 0.37, green: 0.70, blue: 0.57)]), startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(12)
    }
}
