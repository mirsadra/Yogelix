//  HealthDataViewModel.swift
import Foundation
import HealthKit

class HealthDataViewModel: ObservableObject {
    @Published var heartRateData: [HeartRateData] = []
    @Published var stepsData = ""
    @Published var distanceData: [DistanceData] = []
    @Published var sleepData: [SleepData] = []
    @Published var mindfulnessMinutes: Int = 0
    @Published var bodyMeasurements: BodyMeasurements?
    
    private var healthStore = HKHealthStore()
    private var healthKitManager = HealthKitManager()
    
    init() {
        fetchAllData()
    }
    
    private func fetchAllData() {
        healthKitManager.fetchHeartRateData { [weak self] data in
            DispatchQueue.main.async {
                self?.heartRateData = data
            }
        }
        
        healthKitManager.fetchDailyStepCount(forToday: Date(), healthStore: healthStore) { step in
            if step != 0.0 {
                DispatchQueue.main.async {
                    self.stepsData = String(format: "%.0f", step) // Update to store average steps
                }
            }
        }
        
        healthKitManager.fetchDistanceData { [weak self] data in
            DispatchQueue.main.async {
                self?.distanceData = data
            }
        }

        fetchSleepData()
        fetchMindfulnessData()
        fetchBodyMeasurements()
    }
    
    private func fetchSleepData() {
        healthKitManager.fetchSleepData { [weak self] sleepData in
            DispatchQueue.main.async {
                self?.sleepData = sleepData
            }
        }
    }

    private func fetchMindfulnessData() {
        healthKitManager.fetchMindfulnessData { [weak self] totalMinutes in
            DispatchQueue.main.async {
                self?.mindfulnessMinutes = totalMinutes
            }
        }
    }

    private func fetchBodyMeasurements() {
        healthKitManager.fetchBodyMeasurements { [weak self] bodyMeasurements in
            DispatchQueue.main.async {
                self?.bodyMeasurements = bodyMeasurements
            }
        }
    }

}
