//
//  ProgressCircleView.swift
//  Yogelix
//
//  Created by Mirsadra on 28/01/2024.
//
import SwiftUI

struct ProgressCircleView: View {
    var percentage: CGFloat
    var title: String
    var subtitle: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: percentage)
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeOut(duration: 1), value: percentage)
            
            VStack {
                Text(title)
                    .font(.callout)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 150, height: 150)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
}


struct ProgressCircleViewDestination: View {
    var body: some View {
        VStack {
            Text("Hello World")
        }
    }
}
