//  PoseDetail.swift
import SwiftUI

struct PoseDetail: View {
    var pose: Pose
    
    var body: some View {
        
        VStack{
            Rectangle()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)
            
            CircleImage(image: pose.image)
                .offset(y: -90)
                .padding(.bottom, -130)
            
            VStack(alignment: .leading) {
                
                Text(pose.englishName)
                    .font(.title)
                    .padding(.top, 20)
                HStack {
                    Text(pose.sanskritName)
                        .font(.subheadline)
                    Spacer()
                    Text("\(pose.difficulty)")
                        .font(.subheadline)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("About \(pose.englishName)")
                    .font(.title2)
                Text(pose.formattedPoseMeta)
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
    static var previews: some View {
        PoseDetail(pose: poses[0])
    }
}
