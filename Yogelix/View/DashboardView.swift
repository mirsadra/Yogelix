//  DashboardView.swift
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var poseData: PoseData
    @State private var showHealthSheet = false
    @State private var selectedPose: Pose? = nil
    
    private func greeting() -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return currentHour < 12 ? "Good Morning" : currentHour < 17 ? "Good Afternoon" : "Good Evening"
    }
    
    var favoritePoses: [Pose] {
        poseData.poses.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        ProfileButton()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("\(greeting()),")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Welcome, \(authViewModel.displayName) ❤️")
                                .font(.footnote)
                        }
                        Spacer()
                        HealthButton()
                    }
                    .padding(.horizontal)
                    
                    // Favorite Poses Section
                    if !favoritePoses.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your Favorite Poses")
                                .font(.headline)
                                .padding(.leading)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(favoritePoses, id: \.id) { pose in
                                        PoseThumbnailView(pose: pose, selectedPose: $selectedPose)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .sheet(item: $selectedPose) { pose in
                                PoseDetailView(pose: pose)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}


struct PoseThumbnailView: View {
    let pose: Pose
    @Binding var selectedPose: Pose?
    
    var body: some View {
        VStack {
            pose.image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(pose.isFavorite ? Color.red : Color.clear, lineWidth: 2)
                )
                .shadow(radius: 3)
            
            Text(pose.englishName)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 100)
        }
        .padding(.vertical, 4)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
        .onTapGesture {
            self.selectedPose = pose
        }
    }
}

