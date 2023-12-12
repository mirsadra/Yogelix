//  UserTrophyToolbar.swift
import SwiftUI

struct UserTrophyToolbar: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
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
                    
                        ForEach(authViewModel.userAchievements) { achievement in
                            Image(systemName: "trophy.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(getTrophyColor(for: achievement.id))
                            // Additional view modifiers...
                            
                            Text("\(achievement.count)")
                                .font(.custom("LuckiestGuy-Regular", size: 12))
                                .foregroundColor(.primary)
                        }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await authViewModel.fetchUserProfile()
                await authViewModel.fetchAchievements()
            }
        }
    }
    
    func getTrophyColor(for id: String) -> Color {
        switch id {
        case "gold":
            return .yellow
        case "silver":
            return .gray
        case "bronze":
            return .brown // Adjust color as needed
        default:
            return .black
        }
    }
}

struct UserTrophyToolbar_Previews: PreviewProvider {
    static var previews: some View {
        UserTrophyToolbar()
            .environmentObject(AuthenticationViewModel())
    }
}

