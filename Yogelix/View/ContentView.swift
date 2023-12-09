//  ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    @EnvironmentObject var poseViewModel: PoseViewModel
    
    var body: some View {
        AuthenticatedView(unauthenticated: {
            NavigationView {
                LoginView()
            }
        }, content: {
            if let dailyChallengeManager = authViewModel.dailyChallengeManager {
                authenticatedContent()
                    .environmentObject(dailyChallengeManager)
            } else {
                Text("Loading ...")
            }
        })
    }
    
    @ViewBuilder
    private func authenticatedContent() -> some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "heart.circle.fill")
                }
            
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "figure.run.square.stack.fill")
                }
            
            PoseList()
                .tabItem {
                    Label("Poses", systemImage: "figure.yoga")
                }
            
            UserProfileView()
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "gear.circle.fill")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(PoseViewModel())
            .environmentObject(QuantityDataViewModel())
    }
}
