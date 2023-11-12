// YogaPose.swift
import FirebaseFirestoreSwift

struct YogaPose: Codable, Identifiable {
    @DocumentID var id: String?
    var englishName: String
    var sanskritName: String
    var poseMeta: [String]
    var difficulty: Int

    enum CodingKeys: String, CodingKey {
        case id
        case englishName = "english_name"
        case sanskritName = "sanskrit_name"
        case poseMeta = "pose_meta"
        case difficulty
    }
}

let samplePose = YogaPose(englishName: "Warrior III Pose", sanskritName: "Virabhadrasana III", poseMeta: ["Balancing", "Standing", "Strengthening"], difficulty: 3)
