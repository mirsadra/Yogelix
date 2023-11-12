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

/*        // Firebase Emulator (Auth)
 Auth.auth().useEmulator(withHost: "localhost", port: 9099)
 
 // Firebase Emulator (Cloud Firestore)
 Firestore.firestore().useEmulator(withHost: "localhost", port: 8080)
 
 let settings = Firestore.firestore().settings
 settings.cacheSettings = MemoryCacheSettings()
 settings.isSSLEnabled = false
 Firestore.firestore().settings = settings
 return true
 
 // Firebase Emulator (Cloud Storage)
 Storage.storage().useEmulator(withHost: "localhost", port: 9199)
 return true
 
 // Firebase Emulator (Cloud Functions)
 Functions.functions().useEmulator(withHost: "localhost", port: 5001)
 return true
 
 }
 }
 */

@main
struct YogelixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthenticationViewModel()  // @StateObject is source of truth
    
    var body: some Scene {
        WindowGroup {
            if viewModel.authenticationState == .authenticated {
                // Replace with your authenticated user view
                ContentView(exercise: DailyExercise.sampleExercises)
                    .environmentObject(viewModel)
            } else {
                // Login view for unauthenticated users
                NavigationView {
                    LoginView()
                        .environmentObject(viewModel)
                }
            }
        }
    }
}
