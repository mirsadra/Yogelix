// PoseViewModel.swift
import SwiftUI
import Foundation
import Combine

// My current PoseViewModel loads an array of Pose from the JSON file.
final class PoseViewModel: ObservableObject {
    @Published var poses: [Pose] = []
    @Published var lastUpdated: Date?
    
    // Computed property to extract unique categories from all poses
    var categories: [MetadataCategory] {
        let allCategories = poses.flatMap { $0.metadata }  // Create an array with duplication: [Yogelix.MetadataCategory.hipOpening, Yogelix.MetadataCategory.seated..]
        let uniqueCategories = Set(allCategories)
        return Array(uniqueCategories).sorted { $0.rawValue < $1.rawValue }
    }
    
    // Computed property to get the latest content
    var latestContent: [LatestContent] {
        // Here we're assuming you define 'latest' as the most recent poses based on some criteria
        // For this example, let's take the first 5 poses and make some assumptions about the other properties
        return poses.prefix(5).map { pose in
            // Assuming 'imageName' is a property of 'Pose' and 'duration' is a string representation of some duration logic
            LatestContent(id: UUID(), pose: pose, title: pose.englishName, image: pose.imageName, duration: "\(pose.steps.count * 2) mins", level: pose.level)
        }
    }

    init() {
        self.poses = load("updated_data.json")
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

struct YogaData: Codable {
    var poses: [Pose]
}



/*
You can simply call it by: (but this doesn't work if you are loading a json file with an array.

 NavigationView {
     List(viewModel.poses, id: \.id) { pose in
         Text(pose.name) // Assuming Pose has a 'name' property
     }
     .navigationBarTitle("Yoga Poses")
 */

/*
 Instead, you have to do it simply to call it:
 
 NavigationView {
     List(viewModel.poses, id: \.id) { pose in
         VStack {
             Text(pose.englishName)

             Text(pose.sanskritName)

             pose.image

         }
     }
     .navigationBarTitle("Yoga Poses")
 }
}
 */
