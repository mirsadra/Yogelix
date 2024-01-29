//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var poseData: PoseData
    @State private var searchText = ""
    @State private var selectedCategory: MetadataCategory? // Add this line to track the selected category
    
    var body: some View {
        NavigationView {
            VStack {
                
                // MARK: - Metadata Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {

                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {

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
                            //                            ForEach(poseData.latestContent, id: \.id) { content in
                            //                                LatestContentView(content: content)
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

                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Discover")
    }
}

#Preview {
    DiscoverView()
        .environmentObject(PoseData())
}
