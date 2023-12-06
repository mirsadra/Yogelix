//  UserProfileView.swift
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
        Form {
            Section {
                VStack {
                    HStack {
                        Spacer()
                        ProfileView()
                        Spacer()
                    }
                }
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            
            
            // MARK: - Display User's name:
            Section("Name") {
                Text(authViewModel.fullName)
            }
            
            Section("Email") {
                Text(authViewModel.displayName)
            }
            
            Section {
                Button(role: .cancel, action: signOut) {
                    HStack {
                        Spacer()
                        Text("Sign out")
                        Spacer()
                    }
                }
            }
            Section {
                Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
                    HStack {
                        Spacer()
                        Text("Delete Account")
                        Spacer()
                    }
                }
            }
        }
        
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await authViewModel.fetchUserProfile()
            }
        }
        
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .analyticsScreen(name: "\(Self.self)")
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView()
                .environmentObject(AuthenticationViewModel())
        }
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
