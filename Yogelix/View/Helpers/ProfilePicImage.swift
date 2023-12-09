//  ProfileImageView.swift
import SwiftUI
import UIKit

struct ProfilePicImage: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showImagePicker = false
    @State var color = Color.primary
    @State private var imageDataToUpload: Data?

    func uploadImage() {
        showImagePicker = true
    }
    
    func removeImage() {
        authViewModel.removeProfileImage()
    }
    
    var body: some View {
        HStack {
            if let url = URL(string: authViewModel.profilePicUrl), !authViewModel.profilePicUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
                            .shadow(radius: 7)
                            
                    default:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.secondary, lineWidth: 3))
                    .shadow(radius: 7)
                
                ColorPicker("", selection: $color)
                    .labelsHidden() // Optionally hide the label of ColorPicker
            }
        }
        .contextMenu {
            Button {
                uploadImage()
            } label: {
                Label("Upload Photo", systemImage: "square.and.arrow.up.circle.fill")
            }
            Button {
                removeImage()
            } label: {
                Label("Remove Photo", systemImage: "trash.circle.fill")
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImageData: $imageDataToUpload)
        }
        .onChange(of: imageDataToUpload) {
            if let imageData = imageDataToUpload {
                Task {
                    await authViewModel.uploadProfileImage(imageData)
                }
            }
        }
    }

}

#Preview {
    ProfilePicImage()
        .environmentObject(AuthenticationViewModel())
}
