//  ProfileButton.swift
//  Description: A refined view component for displaying the user's profile picture and navigatign to user profile.

import SwiftUI

struct ProfileButton: View {
    var body: some View {
        NavigationStack {
            NavigationLink(destination: UserProfileView()) {
                ProfilePicImage()
            }
        }
    }
}


