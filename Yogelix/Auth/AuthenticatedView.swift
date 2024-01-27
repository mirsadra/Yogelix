//  AuthenticatedView.swift
import SwiftUI

struct AuthenticatedView<Content>: View where Content: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var presentingLoginScreen = false

    @ViewBuilder var content: () -> Content

    // IntroductionView is a placeholder for your custom view
    var introductionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<4) { index in // Assuming you have 4 images
                    VStack(spacing: 10) {
                        Text("Yogelix")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.primary)

                        Text("Discover the Art of Yoga")
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Image("yoga_image_\(index)") // Use your actual image names
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .clipped()

                        Text("Explore various yoga poses and routines")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
    }


    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack {
            switch authViewModel.authenticationState {
                case .unauthenticated, .authenticating:
                    VStack {
                        introductionView // Your introduction scroll view
                        
                        Button("Tap here to log in.") {
                            authViewModel.switchFlow()
                            presentingLoginScreen.toggle()
                        }
                    }
                    .sheet(isPresented: $presentingLoginScreen) {
                        // Replace LoginView() with your actual login view
                        LoginView()
                            .environmentObject(authViewModel)
                    }
                case .authenticated:
                    VStack {
                        content()
                    }
            }
        }
    }
}

