//  Ring.swift
import SwiftUI

struct Ring: View {
    var progress: CGFloat // Value between 0 and 1
    var startColor: Color
    var endColor: Color
    var ringWidth: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let progress = 1.0 - progress // SwiftUI's Circle starts from the top, so we subtract from 1.0 for a clockwise fill

            Circle()
                .stroke(lineWidth: ringWidth)
                .opacity(0.3)
                .foregroundColor(endColor)
                .frame(width: size, height: size)

            Circle()
                .trim(from: progress, to: 1)
                .stroke(AngularGradient(gradient: .init(colors: [startColor, endColor]), center: .center), style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .rotationEffect(Angle(degrees: 270)) // Starts from the top
                .frame(width: size, height: size)
        }
    }
}

