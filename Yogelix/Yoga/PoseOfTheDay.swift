// PoseOfTheDay.
import SwiftUI

struct PoseOfTheDay: View {
    @StateObject var modelData = ModelData()
    @State private var selectedPose: Pose?
    @State private var isFavorite: Bool = false
    @State private var lastUpdated: Date?
    
    @State var date: Date?

    var body: some View {
        // Card View
        ZStack {
            // Dynamic gradient background based on difficulty
            gradientBackground(for: selectedPose?.difficulty ?? 1)
                .frame(width: 360, height: 260) // Increased height for the image
                .cornerRadius(20)
            
                .overlay(
                    // Displaying today's date
                    Text(Date(), formatter: dateFormatter)
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding(.bottom, 10), // Adjust padding as needed
                    alignment: .bottom // Aligns the date at the bottom
                )
            
            VStack {
                // Check if there is a selected pose
                if let pose = selectedPose {
                    CircleImage(image: pose.image)
                        .offset(y: -130)
                        .padding(.bottom, -130) // Move the image to the top of the card

                    VStack(alignment: .leading) {
                        HStack {
                            Text(pose.englishName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Spacer()
                            // Favorite Toggle
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .white)
                                .onTapGesture {
                                    isFavorite.toggle()
                                }
                        }
                        Text(pose.sanskritName)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.75))

                        // Chakra Symbols
                        HStack {
                            ForEach(pose.relatedChakras, id: \.self) { chakraID in
                                Text(modelData.uniqueChakras.first { $0.id == chakraID }?.element ?? "")
                                    .foregroundColor(.white)
                            }
                        }

                        // Recommended For Information
                        Text("Heart Rate: \(pose.recommendedFor.heartRate)")
                            .foregroundColor(.white)
                        Text("Energy Burned: \(pose.recommendedFor.activeEnergyBurned)")
                            .foregroundColor(.white)
                        Text("Exercise Minutes: \(pose.recommendedFor.exerciseMinutes)")
                            .foregroundColor(.white)
                    }
                    .padding([.bottom, .horizontal])
                }
            }
        }
        .onAppear {
            selectedPose = modelData.poses.randomElement()
            isFavorite = selectedPose?.isFavorite ?? false
        }
        .frame(width: 360, height: 260)
    }
    
    private func updatePoseIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        if lastUpdated == nil || lastUpdated! < today {
            selectedPose = modelData.poses.randomElement()
            isFavorite = selectedPose?.isFavorite ?? false
            lastUpdated = today
        }
    }

    private func gradientBackground(for difficulty: Int) -> LinearGradient {
        let colors: [Color] = difficulty <= 2 ? [.green, .blue] : [.orange, .red]
        return LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// DateFormatter for displaying the date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

struct PoseOfTheDay_Previews: PreviewProvider {
    static var previews: some View {
        PoseOfTheDay()
    }
}
