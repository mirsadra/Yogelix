//  UserProfileView.swift
import SwiftUI
import FirebaseAnalyticsSwift
import FirebaseFirestore
import FirebaseAuth

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
    @State private var userData = UserData(image: "Placeholder", age: 18, weight: 30, height: 140, yogaExperienceYears: 0, gender: .other, bodyType: .other)
    
    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut()
    }
    
    var body: some View {
        Form {
            Section {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 100 , height: 100)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .clipped()
                            .padding(4)
                            .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
                        Spacer()
                    }
                    Button(action: {}) {
                        Text("Edit")
                    }
                }
            }
            .listRowBackground(Color(UIColor.systemGroupedBackground))
            Section("Email") {
                Text(viewModel.displayName)
            }
            Section(header: Text("Personal Information")) {
                Picker("Age", selection: $userData.age) {
                    ForEach(ageRange, id: \.self) { age in
                        Text("\(age)").tag(age)
                    }
                }
                Picker("Weight (kg)", selection: $userData.weight) {
                    ForEach(weightRange, id: \.self) { weight in
                        Text("\(Int(weight))").tag(weight)
                    }
                }
                Picker("Height (cm)", selection: $userData.height) {
                    ForEach(heightRange, id: \.self) { height in
                        Text("\(Int(height))").tag(height)
                    }
                }
                Picker("Gender", selection: $userData.gender) {
                    ForEach(Gender.allCases, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                }
                Picker("Body Type", selection: $userData.bodyType) {
                    ForEach(BodyType.allCases, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                }
                Picker("Yoga Experience (Years)", selection: $userData.yogaExperienceYears) {
                    ForEach(yogaExperienceRange, id: \.self) { years in
                        Text("\(years)").tag(years)
                    }
                }
            }
            Button("Save", action: saveUserData)
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
        .analyticsScreen(name: "\(Self.self)")
        .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                            isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
            Button("Delete Account", role: .destructive, action: deleteAccount)
            Button("Cancel", role: .cancel, action: { })
        }
    }
    private func saveUserData() {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let userDataDictionary: [String: Any] = [
            "age": userData.age,
            "weight": userData.weight,
            "height": userData.height,
            "yogaExperienceYears": userData.yogaExperienceYears,
            "gender": userData.gender.rawValue,
            "bodyType": userData.bodyType.rawValue
        ]
        
        db.collection("users").document(userUID).setData(userDataDictionary) { error in
            if let error = error {
                // Handle the error appropriately
                print("Error saving user data: \(error)")
            } else {
                // Data saved successfully
                print("User data saved successfully")
            }
        }
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
