//  LatestContentView.swift
import SwiftUI

struct LatestContent: Identifiable {
    let id: UUID
    let pose: Pose
    var title: String
    var image: String // This would typically be a URL or image name
    var duration: String
    var level: String
}

struct LatestContentView: View {
    var content: LatestContent

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(content.image) // Replace with AsyncImage if loading from URL
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 100)
                .clipped()
                .cornerRadius(8)

            Text(content.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)

            HStack {
                Text(content.duration)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(content.level)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 150)
        .padding(.vertical)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
