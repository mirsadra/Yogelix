//  ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        AuthenticatedView(unauthenticated: {
            NavigationView {
                LoginView()
            }
        }, content: {
            TabView {
                MainView()
                    .tabItem {
                        Label("Figma", systemImage: "heart.circle.fill")
                    }
                
                DiscoverView()
                    .tabItem {
                        Label("Discover", systemImage: "figure.run.square.stack.fill")
                    }
                
                LogYogaExerciseView()
                    .tabItem {
                        Label("Challenge", systemImage: "flag.checkered.circle.fill")
                    }
                

                UserProfileView()
                    .badge("!")
                    .tabItem {
                        Label("Account", systemImage: "gear.circle.fill")
                    }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(ModelData())
            .environmentObject(QuantityDataViewModel())
    }
}
