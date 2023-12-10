//  ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    @EnvironmentObject var poseViewModel: PoseViewModel
    @EnvironmentObject var challengeManager: DailyChallengeManager
    
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
                authenticatedContent()
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
            // Create a sample UserData instance
            let sampleUserData = UserData(userId: "sampleUserId")

            // Use the PoseViewModel initialized for the preview
            let poseViewModel = PoseViewModel()

            // Assuming your PoseViewModel can provide an array of Pose
            let poses = poseViewModel.poses

            // Initialize the DailyChallengeManager with the sample data
            let dailyChallengeManager = DailyChallengeManager(poses: poses, userData: sampleUserData, poseViewModel: poseViewModel)

            return ContentView()
                .environmentObject(AuthenticationViewModel())
                .environmentObject(poseViewModel)
                .environmentObject(QuantityDataViewModel())
                .environmentObject(dailyChallengeManager)
        }
}
