//  Pose.swift
import Foundation
import SwiftUI

struct Pose: Hashable, Codable, Identifiable {
    var id: Int
    var englishName: String
    var sanskritName: String
    var steps: [Step]
    var metadata: [MetadataCategory]
    var difficulty: Int
    var benefits: [String]
    var precautions: [String]
    var level: String
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    var isFavorite: Bool
    var relatedChakras: [Int]
    var recommendedFor: RecommendedFor
    var chakraDetails: [ChakraDetail]
}

struct Step: Hashable, Codable {
    var name: String
    var description: String
}

enum MetadataCategory: String, Codable, CaseIterable {
    case hipOpening = "Hip Opening"
    case seated = "Seated"
    case twist = "Twist"
    case forwardBend = "Forward Bend"
    case standing = "Standing"
    case core = "Core"
    case strengthening = "Strengthening"
    case chestOpening = "Chest Opening"
    case backbends = "Backbends"
    case restorative = "Restorative"
    case armBalance = "Arm Balance"
    case balancing = "Balancing"
    case inversion = "Inversion"
    case binding = "Binding"
    case kneeling = "Kneeling"
    // Add more categories as needed
}

enum HeartRateCategory: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case veryLow = "Very Low"
    case mediumToHigh = "Medium to High"
    case lowToMedium = "Low to Medium"
    case veryHigh = "Very High"
    // Add more categories if needed
}

enum EnergyBurnedCategory: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case veryLow = "Very Low"
    case veryHigh = "Very High"
    // Add more categories if needed
}

enum ExerciseMinutesCategory: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case veryLow = "Very Low"
    case veryHigh = "Very High"
    // Add more categories if needed
}

// Update the RecommendedFor struct
struct RecommendedFor: Hashable, Codable {
    var heartRate: HeartRateCategory
    var activeEnergyBurned: EnergyBurnedCategory
    var exerciseMinutes: ExerciseMinutesCategory
}

// Define a new struct for Chakra Details
struct ChakraDetail: Hashable, Codable, Identifiable {
    var id: Int
    var name: Category
    enum Category: String, CaseIterable, Codable {
        case root = "Root"
        case sacral = "Sacral"
        case solarPlexus = "Solar Plexus"
        case heart = "Heart"
        case throat = "Throat"
        case thirdEye = "Third Eye"
        case crown = "Crown"
    }
    var element: String
    var numberOfPetals: Int
    var location: String
    var focus: [String]
    var color: String
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}

