//  PoseDetailView.swift
import SwiftUI

struct PoseDetailView: View {
    @EnvironmentObject var poseData: PoseData
    let pose: Pose
    
    var poseIndex: Int {
        poseData.poses.firstIndex(where: { $0.id == pose.id })!
    }
    
    func intensityLevel(for level: String) -> Double {
        switch level {
        case "Very Low":
            return 0.1
        case "Low":
            return 0.2
        case "Low to Medium":
            return 0.4
        case "Medium":
            return 0.6
        case "Medium to High":
            return 0.8
        case "High":
            return 0.9
        case "Very High":
            return 1.0
        default:
            return 0.0
        }
    }
    
    func intensityBar(for level: String) -> some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.3)
                        .foregroundColor(Color(UIColor.systemTeal))
                    
                    Rectangle()
                        .frame(width: geometry.size.width * intensityLevel(for: level), height: 8)
                        .foregroundColor(intensityColor(for: level))
                        .animation(.easeIn, value: intensityLevel(for: level))
                }
                .cornerRadius(4)
            }
        }
        
        func intensityColor(for level: String) -> Color {
            switch level {
            case "Very Low", "Low":
                return .green
            case "Low to Medium":
                return .yellow
            case "Medium":
                return .orange
            case "Medium to High":
                return .red
            case "High", "Very High":
                return .purple
            default:
                return .gray
            }
        }
    
    // MARK: - View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                CircleImage(image: pose.image)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                Divider()
                HStack {
                    Text("\(pose.englishName)")
                        .font(.title2) // Make the font larger and more prominent
                        .fontWeight(.bold) // Increase the weight of the font to make it stand out
                        .padding(.vertical, 5) // Add some padding to give it room to breathe
                    FavoriteButton(isSet: $poseData.poses[poseIndex].isFavorite) // Pose is favorite or not
                }
                Text("\(pose.sanskritName)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                LevelIndicator(level: pose.level)
                Divider()

                // Meta data like a button
                ForEach(pose.metadata, id: \.self) { meta in
                    Text("\(meta.rawValue)")
                }
                .font(.callout)
                .padding(.horizontal, 10) // Padding to provide some space on sides
                .frame(height: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)
                .fixedSize(horizontal: true, vertical: false) // Adjust width dynamically based on content
                Divider()
                
                // Refactored Benefits Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Benefits:")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    
                    ForEach(pose.benefits, id: \.self) { benefit in
                        HStack(alignment: .top) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 20))
                            
                            Text(benefit)
                                .fontWeight(.regular)
                                .padding(.leading, 5)
                        }
                    }
                }
                .padding(.all, 10)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.1)))
                .shadow(radius: 3)
                Divider()
                
                // Refactored Precautions Section
                VStack(alignment: .leading, spacing: 5) {
                    Text("Precautions:")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 5)
                    
                    ForEach(pose.precautions, id: \.self) { precaution in
                        HStack(alignment: .top) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 20))
                            
                            Text(precaution)
                                .fontWeight(.regular)
                                .padding(.leading, 5)
                        }
                    }
                }
                .padding(.all, 10)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(Color.red.opacity(0.1)))
                .shadow(radius: 3)
                Divider()
                
                // Refactored Recommended For Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recommended For:")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.bottom, 2)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Heart Rate:")
                        intensityBar(for: pose.recommendedFor.heartRate.rawValue)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Active Energy Burned:")
                        intensityBar(for: pose.recommendedFor.activeEnergyBurned.rawValue)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Exercise Minutes:")
                        intensityBar(for: pose.recommendedFor.exerciseMinutes.rawValue)
                    }
                }
                .padding(.all, 10)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.secondarySystemBackground)))
                
                
                Divider()
//                Text("Chakra Details:")
//                ForEach(pose.chakraDetails) { chakraDetail in
//                    VStack(alignment: .leading) {
//                        Text("Name: \(chakraDetail.name.rawValue)")
//                        Text("Element: \(chakraDetail.element)")
//                        Text("Number of Petals: \(chakraDetail.numberOfPetals)")
//                        Text("Location: \(chakraDetail.location)")
//                        Text("Color: \(chakraDetail.color)")
//                        chakraDetail.image
//                            .resizable()
//                            .scaledToFit()
//                        Text("Focus:")
//                        ForEach(chakraDetail.focus, id: \.self) { focus in
//                            Text(focus)
//                        }
//                    }
//                }
//                Divider()
            }
            .padding()
        }
        .navigationBarTitle(pose.englishName, displayMode: .inline)
        .environmentObject(PoseData())
    }
}
