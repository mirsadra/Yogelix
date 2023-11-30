//  PosesRow.swift
import SwiftUI

struct PoseRow: View {
    var pose: Pose
    
    var body: some View {
        VStack{
            pose.image
                .resizable()
                .frame(width: 112, height: 112)
            HStack{
                Text(pose.englishName)
                
                Spacer()
                if pose.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
            }
            .padding()
        }
    }
}

struct PoseRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            PoseRow(pose: poses[0])
            PoseRow(pose: poses[1])
        }
        .previewLayout(.fixed(width: 300, height: 40))
    }
}
