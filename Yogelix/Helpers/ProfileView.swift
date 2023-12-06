//  ProfileImageView.swift
import SwiftUI
import UIKit

struct ProfileView: View {
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
        Group {
            if let url = URL(string: authViewModel.profilePicUrl), !authViewModel.profilePicUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                        
                    default:
                        Image(systemName: "person.crop.circle")
                                .symbolRenderingMode(.multicolor)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(color)
                            
                    }
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(color)
                ColorPicker("", selection: $color)
                        .padding()
                
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
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 100)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 3))
        .shadow(radius: 7)
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
    ProfileView()
        .environmentObject(AuthenticationViewModel())
}
