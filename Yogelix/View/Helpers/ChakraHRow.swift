// ChakraHRow.swift
import SwiftUI

struct ChakraHRow: View {
    var chakraDetail: ChakraDetail

    var body: some View {
        VStack {
            Text(chakraDetail.name.rawValue)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.bottom, 5)

            Divider()
                .background(Color.white)
                .padding(.bottom, 5)

            Group {
                ChakraView(label: "Element", value: chakraDetail.element, labelColor: .yellow)
                ChakraView(label: "Location", value: chakraDetail.location, labelColor: .pink)
                ChakraView(label: "Number of Petals", value: "\(chakraDetail.numberOfPetals)", labelColor: .orange)
                ChakraView(label: "Focus", value: chakraDetail.formattedFocus, labelColor: .cyan)
                ChakraView(label: "Color", value: chakraDetail.color, labelColor: .green)
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.63, green: 0.85, blue: 0.90), Color(red: 0.94, green: 0.85, blue: 0.60)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

struct ChakraView: View {
    let label: String
    let value: String
    let labelColor: Color

    var body: some View {
        HStack {
            Text("\(label): ")
                .foregroundColor(labelColor)
                .fontWeight(.medium)
            Text(value)
                .foregroundColor(.white)
        }
        .font(.headline)
    }
}
