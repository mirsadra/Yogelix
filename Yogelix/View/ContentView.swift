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
                authenticatedContent()
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
            
            CreateWorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "flag.2.crossed.circle.fill")
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
            return ContentView()
                .environmentObject(AuthenticationViewModel())
                .environmentObject(PoseViewModel())
                .environmentObject(QuantityDataViewModel())
        }
}
