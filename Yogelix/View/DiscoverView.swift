//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var poseData: PoseData
    @State private var searchText = ""
    @State private var selectedCategory: MetadataCategory? // Add this line to track the selected category
    
    var body: some View {
        NavigationView {
            VStack {
                
            }
        }
        .navigationTitle("Discover")
    }
}

#Preview {
    DiscoverView()
        .environmentObject(PoseData())
}
