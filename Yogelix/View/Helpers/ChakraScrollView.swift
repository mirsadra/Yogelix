// ChakraScrollView.swift
import SwiftUI

struct ChakraScrollView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: 10) {
                    ForEach(ChakraDetail.Category.allCases, id: \.self) { chakraCategory in
                        if let chakraDetail = self.getChakraDetail(for: chakraCategory) {
                            NavigationLink(destination: ChakraPosesView(chakraCategory: chakraCategory, poses: filteredPoses(for: chakraCategory)).environmentObject(poseViewModel)) {
                                ChakraCard(chakraCategory: chakraCategory, chakraDetail: chakraDetail)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func filteredPoses(for chakraCategory: ChakraDetail.Category) -> [Pose] {
        poseViewModel.poses.filter { pose in
            pose.chakraDetails.contains { $0.name == chakraCategory }
        }
    }

    private func getChakraDetail(for category: ChakraDetail.Category) -> ChakraDetail? {
        poseViewModel.poses
            .flatMap { $0.chakraDetails }
            .first(where: { $0.name == category })
    }
}

// MARK: - Chakra part in DiscoverView
struct ChakraCard: View {
    var chakraCategory: ChakraDetail.Category
    var chakraDetail: ChakraDetail

    var body: some View {
        VStack {
            CircleImage(image: chakraDetail.image)
                .padding() // Add some padding to give space around the image.
            
            Text(chakraDetail.element) // Displaying the emoji
                .frame(width: 140, height: 30) // Define the frame to ensure consistent sizing.
                .background(Color.gray.opacity(0.1)) // A subtle background color for the text.
                .cornerRadius(10) // Rounded corners for a polished look.
                .padding([.bottom, .horizontal]) // Add padding for better layout
        }
            .background(Color.clear)
            .cornerRadius(8) // Rounded corners for the card itself.
            .shadow(radius: 5) // A shadow for a subtle depth effect.
            .padding() // Horizontal padding to ensure the card doesn't touch the edges of the screen.
        }
}


struct ChakraPosesView: View {
    var chakraCategory: ChakraDetail.Category
    var poses: [Pose]
    @EnvironmentObject var poseViewModel: PoseViewModel
    
    var body: some View {
        List(poses, id: \.id) { pose in
            NavigationLink(destination: PoseDetailView(pose: pose).environmentObject(poseViewModel)) {
                VStack(alignment: .leading) {
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
                                    Text(chakraDetail.element) // Displaying the emoji
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(chakraCategory.rawValue)
    }
}



// Preview
struct ChakraScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ChakraScrollView()
            .environmentObject(PoseViewModel())
    }
}


/*
 // Chakra category name, with additional styling.
 Text(chakraCategory.rawValue)
     .padding() // Add padding to make the text look balanced within the card.
     .frame(width: 140, height: 30) // Define the frame to ensure consistent sizing.
     .background(Color.blue.opacity(0.1)) // A subtle background color for the text.
     .cornerRadius(10) // Rounded corners for a polished look.
     .overlay(
         RoundedRectangle(cornerRadius: 80)
             .stroke(Color.sereneGreen, lineWidth: 1)
     )
     .font(.headline) // Use a headline font for the text to make it stand out.
     .foregroundColor(.sereneGreen) // Use a color that matches the overall theme.
     .padding()
 */
