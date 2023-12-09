//  UserTrophyToolbar.swift
import SwiftUI

struct UserTrophyToolbar: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State var profilePic: Image = Image("avatarMale")
    
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
    
    func firstName() -> String {
        return authViewModel.fullName.components(separatedBy: " ").first ?? ""
    }

    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.seaBlue.opacity(0.4), Color.clear]), startPoint: .top, endPoint: .center)
                    )
                    .frame(height: 200)
                
                HStack {
                    ProfilePicImage()
                        .frame(width: 50, height: 50)
                    
                    Text("\(greeting()), \(firstName())")
                        .font(.custom("LuckiestGuy-Regular", size: 18))
                        .padding()
                    
                    Spacer()
                    
                    Image(systemName: "trophy.circle.fill")
                        .font(Font.custom("SF Pro", size: 24))
                        .foregroundStyle(.gray)
                    
                    Image(systemName: "trophy.circle.fill")
                        .font(Font.custom("SF Pro", size: 32))
                        .foregroundStyle(.yellow)
                    
                    Image(systemName: "trophy.circle.fill")
                        .font(Font.custom("SF Pro", size: 20))
                        .foregroundStyle(.orange)
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await authViewModel.fetchUserProfile()
            }
        }
    }
}

struct UserTrophyToolbar_Previews: PreviewProvider {
    static var previews: some View {
        UserTrophyToolbar()
            .environmentObject(AuthenticationViewModel())
    }
}

