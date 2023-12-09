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
    @StateObject var quantityViewModel = QuantityDataViewModel()
    @StateObject var poseViewModel = PoseViewModel()
    @StateObject var workoutDataViewModel = WorkoutDataViewModel()
    @StateObject var userData = UserData(userId: "userId")
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(poseViewModel)
                    .environmentObject(quantityViewModel)
                    .environmentObject(workoutDataViewModel)
                    .environmentObject(userData)
                    .onAppear {
                        authViewModel.initializeDailyChallengeManager(poseViewModel: poseViewModel)
                    }
            }
            .navigationTitle("Yogel🛸 Main")
        }
    }
}

