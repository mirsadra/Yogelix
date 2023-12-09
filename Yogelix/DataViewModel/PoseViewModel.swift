// PoseViewModel.swift
import SwiftUI
import Combine

// My current PoseViewModel loads an array of Pose from the JSON file.
class PoseViewModel: ObservableObject {
    @Published var poses: [Pose] = []
    @Published var currentPoseOfTheDay: Pose?

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
