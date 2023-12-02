//  CharacteristicTypeViewModel.swift
import Foundation
import HealthKit
import SwiftUI

class CharacteristicTypeViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()

    @Published var biologicalSex: HKBiologicalSexObject?
    @Published var dateOfBirth: DateComponents?

    // Initialization
    init() {
        requestAuthorization()
    }

    // Request Authorization
    private func requestAuthorization() {
        healthKitManager.requestAuthorization { [weak self] success, error in
            if success {
                // Fetch data after authorization is successful
                self?.fetchAllData()
            } else if let error = error {
                print("Authorization failed with error: \(error.localizedDescription)")
            }
        }
    }

    // Fetch all data
    private func fetchAllData() {
        fetchBiologicalSex()
        fetchDateOfBirth()
        // Add more fetch functions as needed
    }

    // Specific Fetch Functions

    // Fetch Biological Sex
    private func fetchBiologicalSex() {
        healthKitManager.readBiologicalSex { [weak self] biologicalSex, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching biological sex: \(error.localizedDescription)")
                } else {
                    self?.biologicalSex = biologicalSex
                }
            }
        }
    }

    // Fetch Date of Birth
    private func fetchDateOfBirth() {
        healthKitManager.readDateOfBirth { [weak self] dateOfBirthComponents, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching date of birth: \(error.localizedDescription)")
                } else {
                    self?.dateOfBirth = dateOfBirthComponents
                }
            }
        }
    }

    // Add more fetch functions as needed for other characteristic types
}
