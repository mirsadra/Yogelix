//  ProfileImageView.swift
import SwiftUI
import UIKit

struct ProfilePicImage: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showImagePicker = false
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
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
                            .shadow(radius: 7)
                            
                    default:
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
            } else {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(authViewModel.profilePicColor)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.secondary, lineWidth: 3))
                        .shadow(radius: 7)
                    
                    ColorPicker("", selection: $authViewModel.profilePicColor)
                        .labelsHidden() // Optionally hide the label of ColorPicker
                }
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
