//  PosesList.swift
import SwiftUI

struct PoseList: View {
    @EnvironmentObject var poseViewModel: PoseViewModel
    
    var body: some View {
        NavigationSplitView {
            List(poseViewModel.poses) { pose in
                NavigationLink(destination: PoseDetailView(pose: pose)) {
                    PoseRow(pose: pose)
                }
            }
            .navigationTitle("Yoga Poses")
            .listStyle(.insetGrouped) // Example of list style customization
        } detail: {
            Text("Select a Pose or Chakra")
        }
    }
}

// Custom Level Indicator View
struct LevelIndicator: View {
    var level: String

    private var maxLevelCount: Int {
        return 4 // Maximum number of circles to represent the highest level
    }
    
    private var levelCount: Int {
        switch level {
        case "Beginner":
            return 1
        case "Beginner to Intermediate":
            return 2
        case "Intermediate":
            return 3
        case "Advanced":
            return 4
        case "Beginner to Advanced":
            return maxLevelCount // Use the max level count for a range
        default:
            return 0
        }
    }
    
    private var levelColor: Color {
        switch level {
        case "Beginner":
            return .green
        case "Beginner to Intermediate":
            return .yellow
        case "Intermediate":
            return .orange
        case "Advanced":
            return .red
        case "Beginner to Advanced":
            return .blue
        default:
            return .gray
        }
    }
    
    var body: some View {
        HStack {
            ForEach(0..<maxLevelCount, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(index < levelCount ? levelColor : .gray)
            }
        }
    }
}

// Custom Row View
struct PoseRow: View {
    let pose: Pose
    
    var body: some View {
        HStack {
            pose.image
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                .shadow(color: .green, radius: 5)
            
            VStack(alignment: .leading) {
                Text(pose.englishName)
                    .font(.headline)
                Text(pose.sanskritName)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                HStack {
                    // Use the LevelIndicator view to show the level
                    LevelIndicator(level: pose.level)
                    Spacer()
                    ForEach(pose.chakraDetails, id: \.self) { chakraDetail in
                        Text(chakraDetail.element) // Displaying the emoji
                            .font(.caption)
                    }
                }

            }
            

        }
    }
}



struct PoseList_Previews: PreviewProvider {
    static var previews: some View {
        PoseList()
            .environmentObject(PoseViewModel())
    }
}
