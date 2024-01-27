//  AnimatedBlobView.swift
import SwiftUI

// MARK: - Animated Blob View
struct AnimatedBlobView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    let index: Int
    let size: CGSize
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        let width = CGFloat.random(in: 100...200)
        let height = width
        
        Circle()
            .fill(Color.green.opacity(0.2))
            .frame(width: width, height: height)
            .position(x: size.width / 2 + xOffset, y: size.height / 2 + yOffset)
            .onAppear {
                withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                    xOffset = CGFloat.random(in: -size.width/2...size.width/2)
                    yOffset = CGFloat.random(in: -size.height/2...size.height/2)
                }
            }
    }
}


// MARK: - Animated Shape View
struct AnimatedShape: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundColor(.blue.opacity(0.5))
            .scaleEffect(isAnimating ? 1.1 : 1)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Background Animation View
struct BackgroundAnimationView: View {
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                ForEach(0..<5) { index in
                    AnimatedBlobView(index: index, size: size)
                }
            }
            .animation(.linear(duration: 30).repeatForever(autoreverses: false), value: true)
        }
    }
}
