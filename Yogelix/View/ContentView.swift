//  ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var poseData: PoseData
    
    var body: some View {
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
            
            PoseListView()
                .tabItem {
                    Label("Poses", systemImage: "figure.yoga")
                }
        }
    }
}
