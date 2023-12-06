//  CardView.swift
import SwiftUI

struct CardView: View {
    
    var body: some View {
        NavigationView {
            HStack {
                Image(systemName: "star.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .frame(width: 32, height: 32)
            }
        }
        .navigationTitle("Setting")
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .previewLayout(.fixed(width: 400, height: 180))
            .presentationCornerRadius(16)
    }
}

