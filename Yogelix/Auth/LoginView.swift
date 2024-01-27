//  LoginView.swift
import SwiftUI
import Combine
import FirebaseAnalyticsSwift
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Image("Sign")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 300, maxHeight: 400)
            Text("Welcome to Yogelix")
                .font(.title)
            
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
                        .frame(width: 16, height: 16)
                    Text("Sign in with Google")
                        .font(.system(size: 18))
                        .bold()
                }
                .frame(width: 343, height: 50) // Set your desired frame size
                .padding(.horizontal, 8) // Adjust padding as needed
            }
            .background(Color(UIColor.secondarySystemBackground))
            .foregroundColor(Color(UIColor.secondaryLabel)) // Set the text color
            .cornerRadius(8) // Optional, for rounded corners
        }
        .listStyle(.plain)
        .padding()
        .analyticsScreen(name: "\(Self.self)")
    }
}

