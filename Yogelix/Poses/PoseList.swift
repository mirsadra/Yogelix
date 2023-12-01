//  PosesList.swift
import SwiftUI

struct PoseList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    
    var filteredPoses: [Pose] {
        modelData.poses.filter { pose in
            (!showFavoritesOnly || pose.isFavorite)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                ForEach(filteredPoses) { pose in
                    NavigationLink {
                        PoseDetail(pose: pose)
                    } label: {
                        PoseRow(pose: pose)
                    }
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
            .environmentObject(ModelData())
    }
}
