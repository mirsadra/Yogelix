//  HealthDataViewModel.swift
import Foundation

class HealthDataViewModel: ObservableObject {
    @Published var heartRateData: [HeartRateData] = []
    @Published var stepsData: [StepsData] = []
    @Published var distanceData: [DistanceData] = []
    
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
        
        healthKitManager.fetchStepsData { [weak self] data in
            DispatchQueue.main.async {
                self?.stepsData = data
            }
        }
        
        healthKitManager.fetchDistanceData { [weak self] data in
            DispatchQueue.main.async {
                self?.distanceData = data
            }
        }
    }
}
