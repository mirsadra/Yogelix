//  QuantityTypeViewModel.swift
import Foundation
import HealthKit
import SwiftUI

class QuantityTypeViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()

    @Published var bodyMassIndexReadings: [(Date, Double)]?
    @Published var heartRateReadings: [(Date, Double)]?
    @Published var walkingRunningDistanceReadings: [(Date, Double)]?
    @Published var activeEnergyBurnReadings: [(Date, Double)]?
    @Published var exerciseMinutesReadings: [(Date, Double)]?

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
        fetchBodyMassIndexReadings()
        fetchHeartRateReadings()
        fetchWalkingRunningDistanceReadings()
        fetchActiveEnergyBurnReadings()
        fetchExerciseMinutesReadings()
        // Add more fetch functions as needed
    }

    // Generic Fetch Data Method
    private func fetchData<T>(fetcher: (@escaping (T?, Error?) -> Void) -> Void, resultHandler: @escaping (T?) -> Void) {
        fetcher { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                resultHandler(result)
            }
        }
    }

    // Specific Fetch Functions

    // Fetch Body Mass Index Readings
    private func fetchBodyMassIndexReadings() {
        fetchData(fetcher: healthKitManager.readBodyMassIndex) { [weak self] readings in
            self?.bodyMassIndexReadings = readings
        }
    }

    // Fetch Heart Rate Readings
    private func fetchHeartRateReadings() {
        fetchData(fetcher: healthKitManager.readHeartRate) { [weak self] readings in
            self?.heartRateReadings = readings
        }
    }

    // Fetch Walking/Running Distance Readings
    private func fetchWalkingRunningDistanceReadings() {
        fetchData(fetcher: healthKitManager.readWalkingRunningDistance) { [weak self] readings in
            self?.walkingRunningDistanceReadings = readings
        }
    }

    // Fetch Active Energy Burn Readings
    private func fetchActiveEnergyBurnReadings() {
        fetchData(fetcher: healthKitManager.readActiveEnergyBurned) { [weak self] readings in
            self?.activeEnergyBurnReadings = readings
        }
    }

    // Fetch Exercise Minutes Readings
    private func fetchExerciseMinutesReadings() {
        fetchData(fetcher: healthKitManager.readExerciseMinutes) { [weak self] readings in
            self?.exerciseMinutesReadings = readings
        }
    }

    // Add more fetch functions as needed for other quantity types
}
