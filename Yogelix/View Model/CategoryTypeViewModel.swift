//  CategoryTypeViewModel.swift
import Foundation
import HealthKit
import SwiftUI

class CategoryTypeViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()

    @Published var sleepAnalysis: [HKCategorySample]?
    @Published var mindfulSessionsReadings: [HKCategorySample]?
    @Published var standHoursReadings: [HKCategorySample]?

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
        fetchSleepAnalysis()
        fetchMindfulSessionsReadings()
        fetchStandHoursReadings()
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

    // Fetch Sleep Analysis
    private func fetchSleepAnalysis() {
        fetchData(fetcher: healthKitManager.readSleepAnalysis) { [weak self] readings in
            self?.sleepAnalysis = readings
        }
    }

    // Fetch Mindful Sessions Readings
    private func fetchMindfulSessionsReadings() {
        fetchData(fetcher: healthKitManager.readMindfulSessions) { [weak self] readings in
            self?.mindfulSessionsReadings = readings
        }
    }

    // Fetch Stand Hours Readings
    private func fetchStandHoursReadings() {
        fetchData(fetcher: healthKitManager.readStandHours) { [weak self] readings in
            self?.standHoursReadings = readings
        }
    }

    // Add more fetch functions as needed for other category types
}
