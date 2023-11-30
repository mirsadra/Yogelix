//
//  RingView.swift
//  Yogelix
//
//  Created by Mirsadra on 28/11/2023.
//

import SwiftUI

struct RingView: View {
    var progress: CGFloat
    var startColor: Color
    var endColor: Color
    var labelText: String
    var systemImageName: String
    var imageColor: Color?
    @Environment(\.colorScheme) var colorScheme // Detects the current color scheme
    
    
    var labelColor: Color {
        colorScheme == .light ? .black : .white
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: progress)
                .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: progress)
            
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                .rotationEffect(Angle(degrees: -90))
            
            Label {
                Text(labelText)
                    .font(.caption)
                    .foregroundColor(labelColor)
            } icon: {
                Image(systemName: systemImageName)
                    .foregroundColor(imageColor)
            }
        }
    }
}

