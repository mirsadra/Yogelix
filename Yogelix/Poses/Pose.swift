//  Poses.swift
import Foundation
import SwiftUI

struct Pose: Hashable, Codable, Identifiable {
    var id: Int
    var englishName: String
    var sanskritName: String
    var poseMeta: [String]
    var difficulty: Int
    var isFavorite: Bool
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    var relatedChakras: [Int]
    var recommendedFor: [String: String]
}




extension Pose {
    var formattedPoseMeta: String {
        poseMeta.joined(separator: ", ")
    }
}
