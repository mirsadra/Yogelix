//  LoginView.swift
import SwiftUI
import UIKit
import Combine
import FirebaseAnalyticsSwift
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var isActive = false
    @State private var emojiOffset: CGFloat = 0
    
    private func signInWithGoogle() {
        Task {
            if await authViewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            Image("Sign")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("🛸")
                .font(.largeTitle)
                .fontWeight(.bold)
                .offset(x: emojiOffset, y: emojiOffset)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        emojiOffset = UIScreen.main.bounds.width * 0.3 // Move the emoji to 30% of the screen width
                    }
                }
            
            // MARK: - Apple Sign In
            SignInWithAppleButton { request in
                authViewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                authViewModel.handleSignInWithAppleCompletion(result)
            }
            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
            .frame(width: 360, height: 50)
            .cornerRadius(8)
            
            // MARK: - Google Sign In
            Button(action: signInWithGoogle) {
                Text("Sign in with Google")
                
                    .frame(width: 335, height: 22)
                    .padding(.vertical, 8)
                    .background(alignment: .leading) {
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                    }
            }
            .buttonStyle(.bordered)
            .foregroundStyle(colorScheme == .light ? .black : .white)
        }
        .listStyle(.plain)
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
          LoginView()
            .preferredColorScheme(.light)
        }
        .environmentObject(AuthenticationViewModel())
    }
}
