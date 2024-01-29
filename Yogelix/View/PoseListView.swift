//  PosesList.swift
import SwiftUI

struct PoseListView: View {
    @EnvironmentObject var poseData: PoseData
    @State private var showFilterView = false

    /// Returns a list of poses filtered based on user preferences.
    private var filteredPoses: [Pose] {
        let allPoses = poseData.filterPoses()
        return poseData.showFavoritesOnly ? allPoses.filter { $0.isFavorite } : allPoses
    }

    var body: some View {
        NavigationSplitView {
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $poseData.filterText)
                }
                ForEach(filteredPoses) { pose in
                    NavigationLink(destination: PoseDetailView(pose: pose)) {
                        PoseRow(pose: pose)
                    }
                }
            }
            .navigationTitle("Yoga Poses")
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showFilterView = true
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilterView) {
                FilterView(filterText: $poseData.filterText, filterDifficulty: $poseData.filterDifficulty, filterBenefits: $poseData.filterBenefits, filterPrecautions: $poseData.filterPrecautions, filterLevel: $poseData.filterLevel, showFavoritesOnly: $poseData.showFavoritesOnly)
            }
            
        } detail: {
            Text("Select a Pose")
        }
    }
}

// MARK: - Custom Level Indicator View
struct LevelIndicator: View {
    var level: String

    private var maxLevelCount: Int { 4 }

    private var levelCount: Int {
        switch level {
        case "Beginner": return 1
        case "Beginner to Intermediate": return 2
        case "Intermediate": return 3
        case "Advanced": return 4
        case "Beginner to Advanced": return maxLevelCount
        default: return 0
        }
    }

    private var levelColor: Color {
        switch level {
        case "Beginner": return .green
        case "Beginner to Intermediate": return .yellow
        case "Intermediate": return .orange
        case "Advanced": return .red
        case "Beginner to Advanced": return .blue
        default: return .gray
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

// MARK: - Custom Row View
/// A view representing a single yoga pose in the list.
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
                HStack {
                    Text(pose.englishName)
                        .font(.headline)
                    if pose.isFavorite {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }
                Text(pose.sanskritName)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                HStack {
                    LevelIndicator(level: pose.level)
                    Spacer()
                    ForEach(pose.chakraDetails, id: \.self) { chakraDetail in
                        Text(chakraDetail.element)
                            .font(.caption)
                    }
                }
            }
        }
    }
}



struct PoseListView_Previews: PreviewProvider {
    static var previews: some View {
        PoseListView()
            .environmentObject(PoseData())
    }
}
