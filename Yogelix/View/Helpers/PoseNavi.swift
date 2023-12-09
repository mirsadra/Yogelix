//  PoseNavi.swift
import SwiftUI

struct PoseNavi: View {
    @ObservedObject var viewModel = PoseViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.poses, id: \.id) { pose in
                VStack {
                    Text(pose.englishName)
                    
                    Text(pose.sanskritName)
                    
                    pose.image
    
                }
            }
            .navigationBarTitle("Yoga Poses")
        }
    }
}


#Preview {
    PoseNavi()
}
