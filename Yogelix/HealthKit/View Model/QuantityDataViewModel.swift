//  QuantityDataViewModel.swift
import Foundation
import CoreData

class QuantityDataViewModel: ObservableObject {
    private var quantityTypeManager = QuantityTypeManager()
    
    // MARK: - Properties for storing processed data
    @Published var currentDayBMI: (value: Double, date: Date)?
    
    @Published var height: (value: Double, date: Date)?
    
    @Published var currentDayActiveEnergyBurned: (total: Double, date: Date)?
    
    @Published var currentDayWalkingRunningDistance: (value: Double, date: Date)?

    @Published var currentDayOxygenSaturation: (value: Double?, date: Date?)?
    
    init() {
        requestHealthKitAuthorization()
        
    }

    // MARK: - Request HealthKit Authorization
    private func requestHealthKitAuthorization() {
        quantityTypeManager.requestAuthorization { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.fetchAllData() // Fetch data only after successful authorization
                } else {
                    self?.error = error // Handle error, update UI accordingly
                }
            }
        }
    }
    
    // MARK: - Error Handling
    @Published var error: Error?
    
    // MARK: - Data Fetching Methods
    func fetchBodyMassIndex() {
        quantityTypeManager.readBodyMassIndex { [weak self] value, date, error in
            DispatchQueue.main.async {
                if let value = value, let date = date {
                    self?.currentDayBMI = (value, date)
                } else {
                    self?.error = error
                }
            }
        }
    }
    
    func fetchHeight() {
        quantityTypeManager.readHeight { [weak self] value, date, error in
            DispatchQueue.main.async {
                if let value = value, let date = date {
                    self?.height = (value, date)
                } else {
                    self?.error = error
                }
            }
        }
    }
    
    
    // MARK: - Active Energy Burned
    func fetchCurrentDayActiveEnergyBurned() {
        quantityTypeManager.readCurrentDayActiveEnergyBurned { [weak self] total, date, error  in
            DispatchQueue.main.async {
                if let total = total, let date = date {
                    self?.currentDayActiveEnergyBurned = (total, date)
                } else {
                    self?.error = error
                }
            }
        }
    }
    
    // MARK: - Walking/Running Distance
    func fetchCurrentDayWalkingRunningDistance() {
        quantityTypeManager.readCurrentDayWalkingRunningDistance { [weak self] total, date, error in
            DispatchQueue.main.async {
                if let total = total, let date = date {
                    self?.currentDayWalkingRunningDistance = (total, date)
                } else {
                    self?.error = error
                }
            }
        }
    }

    // MARK: - Oxygen Saturation
    func fetchCurrentDayOxygenSaturation() {
        quantityTypeManager.readCurrentDayOxygenSaturation { [weak self] average, date, error in
            DispatchQueue.main.async {
                if let averageValue = average, let date = date {
                    // If average oxygen saturation and date are available, set them
                    self?.currentDayOxygenSaturation = (value: averageValue, date: date)
                } else {
                    // If there's an error, handle it
                    self?.error = error
                }
            }
        }
    }

    // MARK: - Fetch All Data
    func fetchAllData() {
        fetchBodyMassIndex()
        fetchHeight()
        fetchCurrentDayActiveEnergyBurned()
        fetchCurrentDayWalkingRunningDistance()
        fetchCurrentDayOxygenSaturation()
    }
}

