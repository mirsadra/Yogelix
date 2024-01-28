// AuthenticatedView.swift
import SwiftUI

struct AuthenticatedView<Content>: View where Content: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var presentingLoginScreen = false
    
    @ViewBuilder var content: () -> Content
    
    var introductionView: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 20) {
                ForEach(0..<4) { index in
                    ZStack {
                        Image("yoga_image_\(index)")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .clipped()
                        VStack {
                            Text("Yogelix")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.primary)
                            Text("Discover the Art of Yoga")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            Text("Explore various yoga poses and routines")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
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
                    ZStack {
                        introductionView
                        Spacer()
                        Button("Looking to Join our big Yogelix Base? 🚀") {
                            authViewModel.switchFlow()
                            presentingLoginScreen.toggle()
                        }
                    }
                    .sheet(isPresented: $presentingLoginScreen) {
                        LoginView()
                            .environmentObject(authViewModel)
                    }
                case .authenticated:
                    content()
            }
        }
    }
}
