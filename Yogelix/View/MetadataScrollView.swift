//  MetadataScrollView.swift
import SwiftUI

struct MetadataScrollView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(MetadataCategory.allCases.prefix(MetadataCategory.allCases.count / 2), id: \.self) { metadataCategory in
                            NavigationLink(destination: MetadataPosesView(metadataCategory: metadataCategory, poses: filteredPoses(for: metadataCategory))) {
                                MetadataCard(metadataCategory: metadataCategory)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(MetadataCategory.allCases.suffix(MetadataCategory.allCases.count / 2), id: \.self) { metadataCategory in
                            NavigationLink(destination: MetadataPosesView(metadataCategory: metadataCategory, poses: filteredPoses(for: metadataCategory))) {
                                MetadataCard(metadataCategory: metadataCategory)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Metadata")
        }
    }
    
    private func filteredPoses(for metadataCategory: MetadataCategory) -> [Pose] {
        poseViewModel.poses.filter { pose in
            pose.metadata.contains(metadataCategory)
        }
    }
}

struct MetadataCard: View {
    var metadataCategory: MetadataCategory
    
    var body: some View {
        Text(metadataCategory.rawValue)
            .font(.callout)
            .padding(.horizontal, 10) // Padding to provide some space on sides
            .frame(height: 40)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .shadow(radius: 5)
            .fixedSize(horizontal: true, vertical: false) // Adjust width dynamically based on content
    }
}

struct MetadataPosesView: View {
    var metadataCategory: MetadataCategory
    var poses: [Pose]
    
    var body: some View {
        List(poses, id: \.id) { pose in
            NavigationLink(destination: PoseDetailView(pose: pose)) {
                VStack(alignment: .leading) {
                    HStack {
                        pose.image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .shadow(color: .green, radius: 5)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text(pose.englishName)
                                    .font(.headline)
                                if pose.isFavorite {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                            Text(pose.sanskritName)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            
                            HStack {
                                LevelIndicator(level: pose.level)
                                Spacer()
                                ForEach(pose.chakraDetails, id: \.self) { chakraDetail in
                                    Text(chakraDetail.element) // Displaying the emoji
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(metadataCategory.rawValue)
    }
}

// Preview
struct MetadataScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MetadataScrollView()
            .environmentObject(PoseViewModel())
    }
}
