//  ActivityRingView.swift
import SwiftUI

struct ActivityRingView: View {
    let progress: CGFloat
    let dayNumber: Int
    var body: some View {
        ZStack {
            // Outer ring representing the goal completion
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            // Inner ring representing the current progress
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(progress >= 1 ? Color.green : Color.blue)
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: progress)
            
            // The number in the center of the ring
            Text("\(dayNumber)")
                .font(.title)
                .fontWeight(.bold)
        }
    }
}


struct RingView: View {
    var progress: CGFloat
    var startColor: Color
    var endColor: Color
    
    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .rotationEffect(Angle(degrees: -90)) // Start from the top
    }
}

