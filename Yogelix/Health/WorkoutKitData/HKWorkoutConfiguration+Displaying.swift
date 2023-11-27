//  HKWorkoutConfiguration+Displaying.swift
import HealthKit

extension HKWorkoutActivityType {
    var displayName: String {
        switch self {
            case.yoga:
                return "Yoga"
            case.flexibility:
                return "Flexibility"
            case.mindAndBody:
                return "Mind and Body"
            case.cooldown:
                return "Cooldown"
            case.preparationAndRecovery:
                return "Prep and Recovery"
            @unknown default:
                return "Other"
        }
    }
}
