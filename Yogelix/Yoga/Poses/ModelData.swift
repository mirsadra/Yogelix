// ModelData.swift
import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var poses: [Pose] = []

    init() {
        poses = load("final.json")
    }

    var categories: [String: [Pose]] {
        Dictionary(grouping: poses.flatMap { $0.getChakraDetails() },
                   by: { $0.name.rawValue }).mapValues { details in
            details.flatMap { detail in poses.filter { $0.getChakraDetails().contains(detail) } }
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

extension ModelData {
    var uniqueChakras: [ChakraDetail] {
        Set(poses.flatMap { $0.getChakraDetails() }).sorted { $0.id < $1.id }
    }

    var uniqueElements: [String] {
        Set(poses.flatMap { $0.chakraDetails.map { $0.element } }).sorted()
    }

    var uniquePetals: [Int] {
        Set(poses.flatMap { $0.chakraDetails.map { $0.numberOfPetals }}).sorted()
    }

    var uniqueLocations: [String] {
        Set(poses.flatMap { $0.chakraDetails.map { $0.location }}).sorted()
    }
}
