//  YogelixApp.swift
import SwiftUI
import Firebase

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
    @State private var quantityViewModel = QuantityDataViewModel()
    @State private var modelData = ModelData()
    
    
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
                        
                        ContentView()
                            .tabItem {
                                Label("Poses", systemImage: "figure.yoga")
                            }
                        
                        DailyExerciseView(practices: DailyPractice.dailyPractices)
                            .tabItem {
                                Label("Exercise", systemImage: "flag.2.crossed.circle")
                            }
                        
                        YogaCustomWorkoutView()
                            .tabItem {
                                Label("Workout", systemImage: "applewatch")
                            }
                        
                        MainView(viewModel: quantityViewModel)
                            .tabItem {
                                Label("HR View", systemImage: "figure")
                            }
                        
                        UserProfileView()
                            .badge("!")
                            .tabItem {
                                Label("Account", systemImage: "person")
                            }
                    }
                    .environmentObject(viewModel)
                    .environmentObject(modelData)
                    .environmentObject(quantityViewModel)
                })
            }
        }
}
