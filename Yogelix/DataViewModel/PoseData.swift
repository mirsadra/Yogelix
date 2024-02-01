// PoseData.swift
import SwiftUI
import Foundation
import Combine
import CoreData

// My current PoseData loads an array of Pose from the JSON file.
class PoseData: ObservableObject {
    @Published var poses: [Pose] = []
    @Published var lastUpdated: Date?
    
    // Filter criteria properties
    @Published var filterText: String = ""
    @Published var filterDifficulty: Int? = nil
    @Published var filterBenefits: String = ""
    @Published var filterPrecautions: String = ""
    @Published var filterLevel: String = ""
    @Published var showFavoritesOnly: Bool = false
    
    private var favoritesKey = "favoritePoses"
    
    // Method to filter poses based on the criteria
    func filterPoses() -> [Pose] {
        return poses.filter { pose in
            (filterText.isEmpty || pose.englishName.lowercased().contains(filterText.lowercased()) || pose.sanskritName.lowercased().contains(filterText.lowercased())) &&
            (filterDifficulty == nil || pose.difficulty == filterDifficulty) &&
            (filterBenefits.isEmpty || pose.benefits.contains(where: { $0.lowercased().contains(filterBenefits.lowercased()) })) &&
            (filterPrecautions.isEmpty || pose.precautions.contains(where: { $0.lowercased().contains(filterPrecautions.lowercased()) })) &&
            (filterLevel.isEmpty || pose.level.lowercased().contains(filterLevel.lowercased()))
        }
    }

    
    init() {
        self.poses = load("updated_data.json")
        loadFavoritePoses()
    }
    
    // MARK: - Favorite Pose Persistency
    private func saveFavoritePoses() {
        let ids = poses.filter { $0.isFavorite }.map { $0.id }
        UserDefaults.standard.set(ids, forKey: favoritesKey)
    }

    private func loadFavoritePoses() {
        let ids = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        for id in ids {
            if let index = poses.firstIndex(where: { $0.id == id }) {
                poses[index].isFavorite = true
            }
        }
    }

    func toggleFavorite(for pose: Pose) {
        if let index = poses.firstIndex(where: { $0.id == pose.id }) {
            poses[index].isFavorite.toggle()
            saveFavoritePoses()
        }
    }
    

    func load<T: Decodable>(_ filename: String) -> T {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil),
              let data = try? Data(contentsOf: file) else {
            fatalError("Couldn't load \(filename) from main bundle.")
        }
        
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {

            fatalError("Couldn't parse \(filename) as \(T.self)")
        }
        return decoded
    }
}

