// UserProfileView.swift
import SwiftUI
import FirebaseAnalyticsSwift
import FirebaseFirestore
import FirebaseAuth

struct UserProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    @State var presentingConfirmationDialog = false
    @State private var profileImage: Image = Image("avatarMale")
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        NavigationView {
            List {
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
                    Button(action: {
                        authViewModel.shouldSignOut()
                        authViewModel.authenticationState = .unauthenticated
                    }, label: {
                        Text("Sign Out")
                    })
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
                    await userProfileViewModel.fetchUserProfile()
                }
            }
            .analyticsScreen(name: "\(Self.self)")
        }
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
