import SwiftUI
import FirebaseAnalyticsSwift
import FirebaseFirestore
import FirebaseAuth

struct UserProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State var presentingConfirmationDialog = false
    @State private var profileImage: Image = Image("avatarMale")
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    private func signOut() {
        authViewModel.signOut()
    }

    var body: some View {
        NavigationView {
            List {
                // Profile Picture and Email Section
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            ProfilePicImage()
                                .frame(width: 140, height: 140)
                            Spacer()
                        }
                    }
                }
                .listRowBackground(Color(UIColor.systemGroupedBackground))

                Section("Email") {
                    Text(authViewModel.displayName)
                }
                
                // Account Section
                Section(header: Text("Account")) {
                    NavigationLink(destination: ManageSubscriptionView()) {
                        Label("Manage Subscription", systemImage: "creditcard")
                    }
                    NavigationLink(destination: RestorePurchasesView()) {
                        Label("Restore Purchases", systemImage: "arrow.clockwise.circle")
                    }
                }
                
                // Preferences Section with Icons
                Section(header: Text("Preferences")) {
                    NavigationLink(destination: RateUsView()) {
                        Label("Rate Us", systemImage: "star.fill")
                    }
                    NavigationLink(destination: AppleHealthView()) {
                        Label("Apple Health", systemImage: "heart.text.square")
                    }
                }

                // Legal Section with Icons
                Section(header: Text("Legal")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }
                    NavigationLink(destination: TermsOfUseView()) {
                        Label("Terms of Use", systemImage: "doc.text")
                    }
                }

                // Sign out and Delete Account
                Section {
                    Button("Sign Out", action: signOut)
                    Button("Delete Account", action: { presentingConfirmationDialog.toggle() })
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .confirmationDialog("Are you sure you want to delete your account?", isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
                Button("Delete Account", role: .destructive) {
                    // Implement account deletion logic
                }
            }
            .onAppear {
                Task {
                    await authViewModel.fetchUserProfile()
                }
            }
            .analyticsScreen(name: "\(Self.self)")
        }
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock AuthenticationViewModel if necessary
        let mockAuthViewModel = AuthenticationViewModel()

        UserProfileView()
            .environmentObject(mockAuthViewModel) // Providing the mock environment object
    }
}


/*
 
 @Environment(\.dismiss) var dismiss
 
 
 
 private func deleteAccount() {
 Task {
 if await viewModel.deleteAccount() == true {
 dismiss()
 }
 }
 }
 
 
 
 .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
 isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
 Button("Delete Account", role: .destructive, action: deleteAccount)
 Button("Cancel", role: .cancel, action: { })
 }
 */
