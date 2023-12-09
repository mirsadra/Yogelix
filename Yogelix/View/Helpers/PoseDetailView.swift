//  PoseDetailView.swift
import SwiftUI

struct PoseDetailView: View {
    let pose: Pose

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CircleImage(image: pose.image)
                    .offset(x: 60)
                    .aspectRatio(contentMode: .fit)
                    .animation(.bouncy, value: 1.5)
                    .padding()
                Divider()
                Text("English Name: \(pose.englishName)")
                Divider()
                Text("Sanskrit Name: \(pose.sanskritName)")
                Divider()
                Text("Difficulty: \(pose.difficulty)")
                Divider()
                Text("Level: \(pose.level)")
                Divider()
                Text("Is Favorite: \(pose.isFavorite ? "Yes" : "No")")
                Divider()
                Text("Metadata:")
                ForEach(pose.metadata, id: \.self) { meta in
                    Text(meta)
                }
                Divider()
                Text("Benefits:")
                ForEach(pose.benefits, id: \.self) { benefit in
                    Text(benefit)
                }
                Divider()
                Text("Precautions:")
                ForEach(pose.precautions, id: \.self) { precaution in
                    Text(precaution)
                }
                Divider()
                Text("Related Chakras:")
                ForEach(pose.relatedChakras, id: \.self) { chakra in
                    Text("\(chakra)")
                }
                Divider()
                Text("Recommended For:")
                Text("Heart Rate: \(pose.recommendedFor.heartRate)")
                Text("Active Energy Burned: \(pose.recommendedFor.activeEnergyBurned)")
                Text("Exercise Minutes: \(pose.recommendedFor.exerciseMinutes)")
                Divider()
                Text("Chakra Details:")
                ForEach(pose.chakraDetails) { chakraDetail in
                    VStack(alignment: .leading) {
                        Text("Name: \(chakraDetail.name.rawValue)")
                        Text("Element: \(chakraDetail.element)")
                        Text("Number of Petals: \(chakraDetail.numberOfPetals)")
                        Text("Location: \(chakraDetail.location)")
                        Text("Color: \(chakraDetail.color)")
                        chakraDetail.image
                            .resizable()
                            .scaledToFit()
                        Text("Focus:")
                        ForEach(chakraDetail.focus, id: \.self) { focus in
                            Text(focus)
                        }
                    }
                }
                Divider()
            }
            .padding()
        }
        .navigationBarTitle(pose.englishName, displayMode: .inline)
    }
}
