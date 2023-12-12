//  FocusAreaView.swift
import SwiftUI

struct FocusArea: Identifiable {
    let id: UUID
    var name: String
    var icon: String // Assuming you have SF Symbols or image assets for these icons
}

struct FocusAreaView: View {
    var focusArea: FocusArea

    var body: some View {
        VStack {
            Image(systemName: focusArea.icon) // Replace with your own image if not using SF Symbols
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue) // Choose a color that matches your design
                .padding()

            Text(focusArea.name)
                .font(.caption)
                .foregroundColor(.primary)

            // Optional: if you have some action when tapping the area
            // You can wrap the VStack with a Button or a NavigationLink
        }
        .frame(width: 100, height: 120)
        .background(Color(.systemGray6)) // Light gray background
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// Dummy data for preview and testing
let dummyFocusAreas = [
    FocusArea(id: UUID(), name: "Neck & Shoulder", icon: "figure.walk"),
    FocusArea(id: UUID(), name: "Back & Spine", icon: "lasso")
]

// Preview for the FocusAreaView
struct FocusAreaView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(dummyFocusAreas) { focusArea in
                    FocusAreaView(focusArea: focusArea)
                }
            }
            .padding()
        }
    }
}
