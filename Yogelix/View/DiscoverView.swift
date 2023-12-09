//  DiscoverView.swift
import SwiftUI

struct DiscoverView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    
    var body: some View {
        NavigationSplitView {
            ChakraScrollView()
            List {

            }
        } detail: {
            Text("Select")
        }
    }
}

#Preview {
    DiscoverView()
        .environmentObject(PoseViewModel())
}
