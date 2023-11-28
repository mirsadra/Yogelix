//  ContentView.swift
import SwiftUI

struct ContentView: View {
    let exercise: [DailyExercise]
    let sampleViewModel = HealthDataViewModel()
    
    var body: some View {
        TabView {
            HealthView(viewModel: sampleViewModel)
                .tabItem {
                    Label("Home", systemImage: "heart.square")
                }
            
            DailyExerciseView(exercise: exercise)
                .tabItem {
                    Label("Exercise", systemImage: "figure.cooldown")
                }
            
            SummaryHealthView()
                .badge(2)
                .tabItem {
                    Label("Challenges", systemImage: "medal.fill")
                }
            
            DailyWorkoutView()
                .tabItem {
                    Label("Daily Workout", systemImage: "figure.yoga")
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
