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
    
    var body: some View {
        VStack {
            Image("Sign")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("Welcome to Yogelix")
                .font(.custom("LuckiestGuy-Regular", size: 22))
            
            // MARK: - Apple Sign In
            SignInWithAppleButton { request in
                authViewModel.signInWithApple(request: request)
            } onCompletion: { result in
                authViewModel.handleAppleSignInCompletion(result: result)
                dismiss()
            }
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(width: 360, height: 50)
            .cornerRadius(8)
            
            // MARK: - Google Sign In
            Button(action: {
                Task {
                    await authViewModel.signInWithGoogle()
                }
            }) {
                HStack {
                    Image("google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text("Sign in with Google")
                        .font(.system(size: 18))
                        .foregroundStyle(.gray)
                        .background(Color(UIColor.opaqueSeparator))
                        .bold()
                }
                .frame(width: 343, height: 50) // Set your desired frame size
                .padding(.horizontal, 8) // Adjust padding as needed
            }
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(Color(UIColor.systemBackground)) // Set the text color
            .cornerRadius(8) // Optional, for rounded corners
        }
        .listStyle(.plain)
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
}

