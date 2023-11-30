//  PosesList.swift
import SwiftUI

struct PoseList: View {
    @State private var showFavoriteOnly = false
    
    var filteredPoses: [Pose] {
        poses.filter { pose in
            (!showFavoriteOnly || pose.isFavorite)
        }
    }
    
    var body: some View {
        
        NavigationSplitView {
            List(filteredPoses) { pose in
                NavigationLink {
                    PoseDetail(pose: pose)
                } label: {
                    PoseRow(pose: pose)
                }
            }
            .navigationTitle("Yoga Poses")
        } detail: {
            Text("Select a Pose")
        }
    }
}


struct PoseList_Previews: PreviewProvider {
    static var previews: some View {
        PoseList()
    }
}
