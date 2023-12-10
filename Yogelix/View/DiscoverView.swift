//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    
    var body: some View {
        NavigationStack {
            ChakraScrollView()
            Spacer()
            MetadataScrollView()
            Spacer()
        }
        .navigationTitle("Discover")
    }
}

#Preview {
    DiscoverView()
        .environmentObject(PoseViewModel())
}
