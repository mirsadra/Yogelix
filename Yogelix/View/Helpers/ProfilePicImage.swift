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
                    default:
                        ProgressView()
                    }
                }
            } else {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.secondary, lineWidth: 3))
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

