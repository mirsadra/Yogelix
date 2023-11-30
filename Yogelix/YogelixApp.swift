//  YogelixApp.swift
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct YogelixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthenticationViewModel()  // @StateObject is source of truth
    
    var body: some Scene {
            WindowGroup {
                AuthenticatedView(unauthenticated: {
                    // Login view for unauthenticated users
                    NavigationView {
                        LoginView()
                            .environmentObject(viewModel)
                    }
                }, content: {
                    // Authenticated user's tab view
                    TabView {
                        HealthView()
                            .tabItem {
                                Label("Home", systemImage: "heart.circle")
                            }
                        
                        DailyExerciseView(practices: DailyPractice.dailyPractices)
                            .tabItem {
                                Label("Exercise", systemImage: "flag.2.crossed.circle")
                            }
                        
                        YogaCustomWorkoutView()
                            .tabItem {
                                Label("Workout", systemImage: "figure.yoga")
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
                    .environmentObject(viewModel)
                })
            }
        }
}
