//  BodyMass.swift
import Foundation


// MARK: - Calculate BMI
func calculateBMI(weight: Double, height: Double) -> Double {
    let heightInMeters = height / 100 // Convert height from cm to meters
    return weight / (heightInMeters * heightInMeters)
}

// Example usage
let weightInKilograms = 70.0 // Replace with actual weight
let heightInCentimeters = 175.0 // Replace with actual height

let bmi = calculateBMI(weight: weightInKilograms, height: heightInCentimeters)
//print("The BMI is \(bmi)")

