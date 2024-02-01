//  ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var poseData: PoseData
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Main", systemImage: "heart.circle.fill")
                }
            
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "figure.run.square.stack.fill")
                }
            
            PoseListView()
                .tabItem {
                    Label("Poses", systemImage: "figure.yoga")
                }
        }
    }
}
