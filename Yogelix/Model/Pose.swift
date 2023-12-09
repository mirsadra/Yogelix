//  Pose.swift
import Foundation
import SwiftUI

struct Pose: Hashable, Codable, Identifiable {
    var id: Int
    var englishName: String
    var sanskritName: String
    var metadata: [String]
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

struct RecommendedFor: Hashable, Codable {
    var heartRate: String
    var activeEnergyBurned: String
    var exerciseMinutes: String
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

