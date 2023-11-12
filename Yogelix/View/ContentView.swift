//  ContentView.swift
import SwiftUI

struct ContentView: View {
    let exercise: [DailyExercise]
    
    var body: some View {
        TabView {
            HealthView()
                .tabItem {
                    Label("Home", systemImage: "heart.square")
                }
            
            DailyExerciseView(exercise: exercise)
                .tabItem {
                    Label("Exercise", systemImage: "figure.cooldown")
                }
            
            ChallengesView()
                .badge(2)
                .tabItem {
                    Label("Challenges", systemImage: "medal.fill")
                }
            
            AIYogaPlanView()
                .tabItem {
                    Label("AI Yoga Plan", systemImage: "figure.yoga")
                }
            
            UserProfileView()
                .badge("!")
                .tabItem {
                    Label("Account", systemImage: "person")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(exercise: DailyExercise.sampleExercises)
            .environmentObject(AuthenticationViewModel())
    }
}
