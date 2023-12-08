//  PosesRow.swift
import SwiftUI

struct PoseRow: View {
    var pose: Pose
    
    var body: some View {
        VStack {
            pose.image
                .resizable()
                .frame(width: 112, height: 112)
            HStack {
                Text(pose.englishName)
                
                Spacer()

                // Difficulty Indicator
                HStack {
                    if pose.difficulty == 3 {
                        Image(systemName: "gauge.with.dots.needle.33percent")
                            .foregroundStyle(.green)
                    } else if pose.difficulty == 2 {
                        Image(systemName: "gauge.with.dots.needle.50percent")
                            .foregroundStyle(.yellow)
                    } else {
                        Image(systemName: "gauge.with.dots.needle.67percent")
                            .foregroundColor(.red)
                    }
                }

                if pose.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                }
            }
            .padding()
        }
    }
}


#Preview {
    let poses = ModelData().poses
    return Group {
        PoseRow(pose: poses[0])
    }
    .previewLayout(.fixed(width: 400, height: 120))
}
