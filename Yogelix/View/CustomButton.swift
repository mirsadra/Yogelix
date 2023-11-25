////  CustomButton.swift
//import SwiftUI
//
//struct CustomButton: View {
//    let title: String
//    let iconName: String
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: iconName)
//                    .foregroundColor(.black) // Change the color as needed
//                Text(title)
//                    .fontWeight(.medium)
//                    .foregroundColor(.black) // Change the color as needed
//            }
//            .padding()
//            .frame(height: 47) // Set the height you want
//            .background(Color.white) // Change the background color as needed
//            .cornerRadius(23.5) // Half of the frame height to make it fully rounded
//            .overlay(
//                RoundedRectangle(cornerRadius: 10) // Half of the frame height to make it fully rounded
//                    .stroke(Color.black, lineWidth: 1) // Change the border color and width as needed
//            )
//        }
//    }
//}
//
//#Preview {
//    CustomButton(title: "Signup", iconName: "arrow.up.circle", action: {
//        // Here you define what the button should do when tapped.
//        print("Button tapped!")
//    })
//}
