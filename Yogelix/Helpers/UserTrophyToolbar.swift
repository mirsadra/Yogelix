//  UserTrophyToolbar.swift
import SwiftUI

struct UserTrophyToolbar: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var userName: String = "User Name"
    @State var profilePic: Image = Image("avatarMale")
    
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack() {
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.seaBlue.opacity(0.4), Color.clear]), startPoint: .top, endPoint: .center)
                        )
                        .frame(height: 200)
                }
                    HStack {
                        profilePic
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                        
                        Text("\(viewModel.displayName)")
                            .font(Font.custom("  Inter", size: 12))
                        
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
        
    }
}

struct UserTrophyToolbar_Previews: PreviewProvider {
    static var previews: some View {
        UserTrophyToolbar()
    }
}

