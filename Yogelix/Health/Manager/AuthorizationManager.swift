//  AuthorizationManager.swift
import Foundation
import HealthKit

class AuthorizationManager {
    private let healthKitManager = HealthKitManager()

    // Method to request authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        healthKitManager.requestAuthorization(completion: completion)
    }
}
