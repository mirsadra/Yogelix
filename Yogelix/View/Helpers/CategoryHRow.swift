//  CategoryHRow.swift
import SwiftUI

struct CategoryHRow: View {
    var pose: Pose
    
    var body: some View {
        NavigationStack {
            NavigationLink("Hip Opening") {
                Text("Poses that has Standing in destination")
                    .navigationTitle("Standing Title")
            }
            
            NavigationLink("Seated") {
                Text("Poses that has Seated in destination")
                    .navigationTitle("Seated Title")
            }
        }
    }
}

struct CategoryHRow_Previews: PreviewProvider {
    static var previews: some View {
        let poseViewModel = PoseViewModel()

    }
}
