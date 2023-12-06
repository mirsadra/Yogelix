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
    @StateObject var authViewModel = AuthenticationViewModel()
    @State private var quantityViewModel = QuantityDataViewModel()
    @State private var modelData = ModelData()
    
    
    var body: some Scene {
            WindowGroup {
                AuthenticatedView(unauthenticated: {
                    NavigationView {
                        LoginView()
                            .environmentObject(authViewModel)
                    }
                }, content: {
                    TabView {
                        MainView()
                            .tabItem {
                                Label("Figma", systemImage: "heart.circle.fill")
                                    .symbolRenderingMode(.multicolor)
                            }
                        
                        ContentView()
                            .tabItem {
                                Label("Poses", systemImage: "figure.yoga")
                            }
                        
//                        DetailView(exercise: <#DailyPractice#>)
//                            .tabItem {
//                                Label("Exercise", systemImage: "flag.2.crossed.circle")
//                            }

                        UserProfileView()
                            .badge("!")
                            .tabItem {
                                Label("Account", systemImage: "person")
                            }
                    }
                    .environmentObject(authViewModel)
                    .environmentObject(modelData)
                    .environmentObject(quantityViewModel)
                })
            }
        }
}
