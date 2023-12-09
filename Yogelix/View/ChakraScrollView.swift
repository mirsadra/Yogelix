// ChakraScrollView.swift
import SwiftUI

struct ChakraScrollView: View {
    @EnvironmentObject var poseViewModel: PoseViewModel

    var body: some View {
        NavigationView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // Iterate over all chakra categories
                    ForEach(ChakraDetail.Category.allCases, id: \.self) { chakraCategory in
                        // Assuming you have a method to get the detail for each category
                        if let chakraDetail = self.getChakraDetail(for: chakraCategory) {
                            NavigationLink(destination: ChakraPosesView(chakraCategory: chakraCategory, poses: filteredPoses(for: chakraCategory))) {
                                ChakraCard(chakraCategory: chakraCategory, chakraDetail: chakraDetail)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Chakras")
            
        }
    }

    private func filteredPoses(for chakraCategory: ChakraDetail.Category) -> [Pose] {
        return poseViewModel.poses.filter { $0.chakraDetails.contains { $0.name == chakraCategory } }
    }

    // Add this method to get the ChakraDetail for a given category
    private func getChakraDetail(for category: ChakraDetail.Category) -> ChakraDetail? {
        // You would have to implement the logic to get the ChakraDetail from your model
        // For example, this might involve filtering the poses to find a pose with the matching chakra detail
        return poseViewModel.poses
            .flatMap { $0.chakraDetails }
            .first(where: { $0.name == category })
    }
}

struct ChakraCard: View {
    var chakraCategory: ChakraDetail.Category
    var chakraDetail: ChakraDetail

    var body: some View {
            VStack {
                // Chakra image, styled as a circle with padding.
                CircleImage(image: chakraDetail.image)
                    .padding() // Add some padding to give space around the image.

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
            }
            .background(Color.clear) 
            .cornerRadius(8) // Rounded corners for the card itself.
            .shadow(radius: 5) // A shadow for a subtle depth effect.
            .padding() // Horizontal padding to ensure the card doesn't touch the edges of the screen.
        }
    
}


// ChakraPosesView.swift
struct ChakraPosesView: View {
    var chakraCategory: ChakraDetail.Category
    var poses: [Pose]

    var body: some View {
        List(poses, id: \.id) { pose in
            Text(pose.englishName)
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
