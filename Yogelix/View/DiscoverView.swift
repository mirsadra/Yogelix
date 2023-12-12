//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    @State private var searchText = ""
    @State private var selectedCategory: MetadataCategory? // Add this line to track the selected category
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding()
                
                // Category Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        // Ensure that poseViewModel actually has a 'categories' property
                        ForEach(poseViewModel.categories, id: \.self) { category in
                            CategoryButton(category: category, selectedCategory: $selectedCategory) // Pass the binding here
                        }
                    }
                    .padding(.horizontal)
                }
                
                // The Latest Section
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
                
                // Focus Area Section
                VStack(alignment: .leading) {
                    Text("Focus Area")
                        .font(.title2)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(poseViewModel.focusAreas, id: \.id) { focusArea in
                                        FocusAreaView(focusArea: focusArea)
                                    }
                                }
                                .padding(.horizontal)
                            }

                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Discover")
        }
    }
}

#Preview {
    DiscoverView()
        .environmentObject(PoseViewModel())
}
