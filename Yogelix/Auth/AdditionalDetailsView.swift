////  AdditionalDetailsView.swift
//import SwiftUI
//import FirebaseFirestore
//
//struct AdditionalDetailsView: View {
//    @EnvironmentObject var userAuth: AuthenticationViewModel
//    @State private var username: String = ""
//    @State private var age: String = ""
//    @State private var gender: String = "male"
//    @State private var height: String = ""
//    @State private var weight: String = ""
//    @State private var experienceLevel: Int = 0
//    @State private var errorMessage: String = ""
//    @State private var showHomePage = false
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Personal Information")) {
//                    TextField("Username", text: $username)
//                    Picker("Gender", selection: $gender) {
//                        Text("Male").tag("male")
//                        Text("Female").tag("female")
//                        Text("Other").tag("other")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    HStack {
//                        Text("Age")
//                        Spacer()
//                        TextField("Enter your age", text: $age)
//                            .keyboardType(.numberPad)
//                            .multilineTextAlignment(.trailing)
//                    }
//                    HStack {
//                        Text("Height (cm)")
//                        Spacer()
//                        TextField("Enter your height", text: $height)
//                            .keyboardType(.numberPad)
//                            .multilineTextAlignment(.trailing)
//                    }
//                    HStack {
//                        Text("Weight (kg)")
//                        Spacer()
//                        TextField("Enter your weight", text: $weight)
//                            .keyboardType(.numberPad)
//                            .multilineTextAlignment(.trailing)
//                    }
//                    Picker("Experience Level", selection: $experienceLevel) {
//                        ForEach(0..<6) { level in
//                            Text("\(level)").tag(level)
//                        }
//                    }
//                }
//                
//                Button("Save Details") {
//                    saveUserDetails()
//                }
//            }
//            .navigationBarTitle("Additional Details")
//            .alert(isPresented: $showHomePage) {
//                Alert(title: Text("Details Saved"), message: Text("Welcome to the Home Page!"), dismissButton: .default(Text("OK")))
//            }
//            .alert(isPresented: .constant(!errorMessage.isEmpty)) {
//                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//            }
//        }
//    }
//    
//    private func saveUserDetails() {
//
//    }
//}
//
//struct AdditionalDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdditionalDetailsView().environmentObject(AuthenticationViewModel())
//    }
//}
