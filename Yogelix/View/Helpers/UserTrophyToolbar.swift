//  UserTrophyToolbar.swift
import SwiftUI

struct UserTrophyToolbar: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    func greeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
            case 6..<12:
                return "Good Morning"
            case 12..<17:
                return "Good Afternoon"
            case 17..<22:
                return "Good Evening"
            default:
                return "Hello"
        }
    }
    
    //    func firstName() -> String {
    //        return authViewModel.fullName.components(separatedBy: " ").first ?? ""
    //    }
    
    var body: some View {
        HStack {
            ProfilePicImage()
                .frame(width: 50, height: 50)
            
            Text("\(greeting()), \(authViewModel.fullName.components(separatedBy: " ").first ?? "\(authViewModel.displayName.components(separatedBy: " "))" )")
                .font(.title3)
                .bold()
        }
        .padding()
        .onAppear {
            Task {
                await userProfileViewModel.fetchUserProfile()
            }
        }
    }
}

struct UserTrophyToolbar_Previews: PreviewProvider {
    static var previews: some View {
        UserTrophyToolbar()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(UserProfileViewModel())
    }
}

