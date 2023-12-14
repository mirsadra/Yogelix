//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    @State private var searchText = ""
    @State private var selectedCategory: MetadataCategory? // Add this line to track the selected category
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                // MARK: - Metadata Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(MetadataCategory.allCases.prefix(MetadataCategory.allCases.count / 2), id: \.self) { metadataCategory in
                            NavigationLink(destination: MetadataPosesView(metadataCategory: metadataCategory, poses: metadataFilteredPoses(for: metadataCategory)).environmentObject(poseViewModel)) {
                                MetadataCard(metadataCategory: metadataCategory)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        ForEach(MetadataCategory.allCases.suffix(MetadataCategory.allCases.count / 2), id: \.self) { metadataCategory in
                            NavigationLink(destination: MetadataPosesView(metadataCategory: metadataCategory, poses: metadataFilteredPoses(for: metadataCategory)).environmentObject(poseViewModel)) {
                                MetadataCard(metadataCategory: metadataCategory)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // MARK: - The Latest Section
                VStack(alignment: .leading) {
                    Text("The Latest")
                        .font(.title2)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(poseViewModel.latestContent, id: \.id) { content in
                                LatestContentView(content: content)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // MARK: - Chakras Section
                VStack(alignment: .leading) {
                    Text("Chakras")
                        .font(.title2)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack(spacing: 10) {
                            ForEach(ChakraDetail.Category.allCases, id: \.self) { chakraCategory in
                                if let chakraDetail = self.getChakraDetail(for: chakraCategory) {
                                    NavigationLink(destination: ChakraPosesView(chakraCategory: chakraCategory, poses: chakraFilteredPoses(for: chakraCategory)).environmentObject(poseViewModel)) {
                                        ChakraCard(chakraCategory: chakraCategory, chakraDetail: chakraDetail)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
    
    private func metadataFilteredPoses(for metadataCategory: MetadataCategory) -> [Pose] {
        poseViewModel.poses.filter { pose in
            pose.metadata.contains(metadataCategory)
        }
    }
    
    private func chakraFilteredPoses(for chakraCategory: ChakraDetail.Category) -> [Pose] {
        poseViewModel.poses.filter { pose in
            pose.chakraDetails.contains { $0.name == chakraCategory }
        }
    }
    
    private func getChakraDetail(for category: ChakraDetail.Category) -> ChakraDetail? {
        poseViewModel.poses
            .flatMap { $0.chakraDetails }
            .first(where: { $0.name == category })
    }
}

#Preview {
    DiscoverView()
        .environmentObject(PoseViewModel())
}
