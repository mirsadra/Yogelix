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
            Text("Are you a Yogelixer?")
                .font(.custom("LuckiestGuy-Regular", size: 22))
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
                HStack {
                    Image("google") // Your Google icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text("Sign in with Google")
                        .font(.system(size: 18))
                        .bold()
                        
                }
                .frame(width: 343, height: 50) // Set your desired frame size
                .padding(.horizontal, 8) // Adjust padding as needed
            }
            .background(colorScheme == .light ? .black : .white) // Set your desired background color here
            .foregroundColor(.white) // Set the text color
            .cornerRadius(8) // Optional, for rounded corners
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
