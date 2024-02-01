//  FavoriteButton.swift
import SwiftUI

struct FavoriteButton: View {
    
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .red : .red)
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
        .environmentObject(PoseData())
}

