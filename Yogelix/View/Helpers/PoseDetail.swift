//  PoseDetail.swift
import SwiftUI

struct PoseDetail: View {
    @EnvironmentObject var modelData: ModelData
    var pose: Pose
    
    var poseIndex: Int {
        modelData.poses.firstIndex(where: { $0.id == pose.id })!
    }
    
    var body: some View {
        
        VStack{
            Rectangle()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage(image: pose.image)
                .offset(y: -90)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(pose.sanskritName)
                        .font(.subheadline)
                    Spacer()
                    Text("Difficulty: \(pose.difficulty) / 3")
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Text(pose.englishName)
                        .font(.title)
                    Spacer()
                    FavoriteButton(isSet: $modelData.poses[poseIndex].isFavorite)
                }
                
                Divider()
                
                Text("About \(pose.englishName)")
                    .font(.title2)
                Text(pose.formattedMetadata)
                    .font(.body)
                
                Text(pose.formattedBenefits)
                    .font(.body)
                

            }
            .padding()
            
            Spacer()
        }
        .navigationTitle(pose.englishName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PoseDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        PoseDetail(pose: ModelData().poses[0])
            .environmentObject(modelData)
    }
}
