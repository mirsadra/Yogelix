// ModelData.swift
import Foundation
import Combine

// Observable Object w/ Published variable.
final class ModelData: ObservableObject {
    @Published var poses: [Pose] = []
    
    init() {
        poses = load("data.json")
    }
    
    var categories: [String: [Pose]] {
        Dictionary(grouping: poses.flatMap { pose in
            pose.chakraDetails.map {
                (pose, $0)
            }
        }, 
                   by: { $0.1.name.rawValue })
        .mapValues { $0.map { $0.0 } }
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

// MARK: - `Set` can be used instead of an array. We use it to ensure that each element appears only once in a collection.
    // You can create `Set` with any element type that conforms to the `Hashable` protocol
extension ModelData {
    // From a collection of poses, extract the element property of each chakraDetail from each pose, remove any duplicates, and then sort these unique elements in order.
    var uniqueElements: [String] {
        Set(poses.flatMap { $0.chakraDetails.map { $0.element } }).sorted()
    }
    
    // Collect the numberOfPetals property from each chakraDetail in each pose, remove any duplicate numbers, and then sort these unique numbers.
    var uniquePetals: [Int] {
        Set(poses.flatMap { $0.chakraDetails.map { $0.numberOfPetals } }).sorted()
    }
    
    var uniqueChakras: [ChakraDetail] {
        Set(poses.flatMap { $0.getChakraDetails() }).sorted { $0.id < $1.id }
    }
}

extension ModelData {
    func poses(forMetadata metadata: String) -> [Pose] {
        // Implement filtering logic based on the metadata
        // For example, return all poses where the metadata array contains the metadata string
        return poses.filter { $0.metadata.contains(metadata) }
    }
}
