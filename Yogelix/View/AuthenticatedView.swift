//  AuthenticatedView.swift
import SwiftUI

struct AnimatedBlobView: View {
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

struct AuthenticatedView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var presentingLoginScreen = false
    @State private var presentingProfileScreen = false
    
    var unauthenticated: Unauthenticated?
    @ViewBuilder var content: () -> Content
    
    public init(unauthenticated: Unauthenticated?, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated
        self.content = content
    }
    
    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = unauthenticated()
        self.content = content
    }
    
    
    var body: some View {
        ZStack {
                    BackgroundAnimationView()
                        .edgesIgnoringSafeArea(.all)

                    switch viewModel.authenticationState {
                    case .unauthenticated, .authenticating:
                        VStack(spacing: 20) {
                            Spacer()
                            Text("Welcome to Yogelix")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(.sereneGreen)
                                .shadow(radius: 10)
                                .padding(.horizontal, 30)
                                .multilineTextAlignment(.center)
                            Text("Your 🤖 Yoga Tutor")
                                .foregroundColor(.sereneGreen.opacity(0.9))
                                .fontWeight(.medium)
                            Spacer()
                            Button(action: {
                                presentingLoginScreen.toggle()
                            }) {
                                Text("Let's connect 🚀")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 40)
                                    .background(Color.white)
                                    .cornerRadius(30)
                                    .shadow(radius: 5)
                            }
                            Spacer()
                            VStack {
                                Text("Powered by:")
                                    .font(.custom("EncodeSansSC", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.sereneGreen.opacity(0.8))
                                Image("appleHealthKitLogo") // Assuming you have a logo image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                                Image("openAIGPT4Logo") // Assuming you have a logo image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 30)
                            }
                            .padding(.bottom, 30)
                        }
                        .sheet(isPresented: $presentingLoginScreen) {
                            AuthenticationView()
                                .environmentObject(viewModel)
                        }

                    case .authenticated:
                        content()
                            .transition(.move(edge: .trailing))
                    }
                }
            }
}



extension AuthenticatedView where Unauthenticated == EmptyView {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.unauthenticated = nil
        self.content = content
    }
}

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




struct AuthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticatedView {
            Text("You're signed in.")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(.yellow)
        }
    }
}
