// ChakraDetailView.swift
import SwiftUI

struct ChakraDetailView: View {
    var chakraDetail: ChakraDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(chakraDetail.name.rawValue)
                .font(.headline)
            Text("Element: \(chakraDetail.element)")
            Text("Location: \(chakraDetail.location)")
            Text("Number of Petals: \(chakraDetail.numberOfPetals)")
            Text("Focus: \(chakraDetail.formattedFocus)")
            Text("Color: \(chakraDetail.color)")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}
