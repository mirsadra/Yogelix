//  CategoryRow.swift
import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Pose]

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items, id: \.id) { pose in
                        NavigationLink(destination: PoseDetail(pose: pose)) {
                            CategoryItem(pose: pose)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryItem: View {
    var pose: Pose
    var body: some View {
        VStack(alignment: .leading) {
            pose.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(pose.englishName)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(
            categoryName: "Some Category",
            items: ModelData().poses
        )
    }
}
