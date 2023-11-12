//  UserData.swift
import Foundation

struct UserData {
    var image: String
    var age: Int
    var weight: Int
    var height: Int
    var yogaExperienceYears: Int
    var gender: Gender
    var bodyType: BodyType
}

enum Gender: String, CaseIterable {
    case male, female, other
}

enum BodyType: String, CaseIterable {
    case ectomorph, mesomorph, endomorph, other
}

let ageRange = Array(18...100)
let weightRange = stride(from: 40, to: 200, by: 1).map { $0 }
let heightRange = stride(from: 140, to: 220, by: 1).map { $0 }
let yogaExperienceRange = Array(0...10)


let sampleData = UserData(image: "Placeholder", age: 30, weight: 72, height: 180, yogaExperienceYears: 0, gender: Gender.male, bodyType: BodyType.ectomorph)

