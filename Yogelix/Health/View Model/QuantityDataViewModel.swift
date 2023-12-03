//  QuantityDataViewModel.swift
import Foundation

class QuantityDataViewModel: ObservableObject {
    
    private var quantityTypeManager = QuantityTypeManager()
    
    // MARK: - Properties for storing processed data
    @Published var currentDayBMI: (value: Double, date: Date)?
    @Published var height: (value: Double, date: Date)?
    
    @Published var currentDayActiveEnergyBurned: Double?
    @Published var lastWeekActiveEnergyBurned: [Date: Double] = [:]
    
    @Published var currentDayWalkingRunningDistance: Double?
    @Published var lastWeekWalkingRunningDistance: [Date: Double] = [:]
    
    @Published var currentDayExerciseMinutes: Double?
    @Published var lastWeekExerciseMinutes: [Date: Double] = [:]
    
    @Published var currentDayHeartRate: (average: Double?, min: Double?, max: Double?)?
    @Published var lastWeekHeartRate: [Date: (average: Double?, min: Double?, max: Double?)] = [:]
    
    @Published var currentDayOxygenSaturation: (average: Double?, min: Double?, max: Double?)?
    @Published var lastWeekOxygenSaturation: [Date: (average: Double?, min: Double?, max: Double?)] = [:]
    
    
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
        quantityTypeManager.readCurrentDayActiveEnergyBurned { [weak self] total, error in
            DispatchQueue.main.async {
                self?.currentDayActiveEnergyBurned = total
                self?.error = error
            }
        }
    }
    
    func fetchLastWeekActiveEnergyBurned() {
        quantityTypeManager.readLastWeekActiveEnergyBurned { [weak self] data, error in
            DispatchQueue.main.async {
                self?.lastWeekActiveEnergyBurned = data ?? [:]
                self?.error = error
            }
        }
    }
    
    // MARK: - Walking/Running Distance
    func fetchCurrentDayWalkingRunningDistance() {
        quantityTypeManager.readCurrentDayWalkingRunningDistance { [weak self] total, error in
            DispatchQueue.main.async {
                self?.currentDayWalkingRunningDistance = total
                self?.error = error
            }
        }
    }
    
    func fetchLastWeekWalkingRunningDistance() {
        quantityTypeManager.readLastWeekWalkingRunningDistance { [weak self] data, error in
            DispatchQueue.main.async {
                self?.lastWeekWalkingRunningDistance = data ?? [:]
                self?.error = error
            }
        }
    }
    
    // MARK: - Exercise Time
    func fetchCurrentDayExerciseMinutes() {
        quantityTypeManager.readCurrentDayExerciseMinutes { [weak self] total, error in
            DispatchQueue.main.async {
                self?.currentDayExerciseMinutes = total
                self?.error = error
            }
        }
    }
    
    func fetchLastWeekExerciseMinutes() {
        quantityTypeManager.readLastWeekExerciseMinutes { [weak self] data, error in
            DispatchQueue.main.async {
                self?.lastWeekExerciseMinutes = data ?? [:]
                self?.error = error
            }
        }
    }
    
    // MARK: - Heart Rate
    func fetchCurrentDayHeartRate() {
        quantityTypeManager.readCurrentDayHeartRate { [weak self] average, min, max, error in
            DispatchQueue.main.async {
                self?.currentDayHeartRate = (average, min, max)
                self?.error = error
            }
        }
    }
    
    func fetchLastWeekHeartRate() {
        quantityTypeManager.readLastWeekHeartRate { [weak self] data, error in
            DispatchQueue.main.async {
                self?.lastWeekHeartRate = data ?? [:]
                self?.error = error
            }
        }
    }
    
    // MARK: - Oxygen Saturation
    func fetchCurrentDayOxygenSaturation() {
        quantityTypeManager.readCurrentDayOxygenSaturation { [weak self] average, min, max, error in
            DispatchQueue.main.async {
                self?.currentDayOxygenSaturation = (average, min, max)
                self?.error = error
            }
        }
    }
    
    func fetchLastWeekOxygenSaturation() {
        quantityTypeManager.readLastWeekOxygenSaturation { [weak self] data, error in
            DispatchQueue.main.async {
                self?.lastWeekOxygenSaturation = data ?? [:]
                self?.error = error
            }
        }
    }
    
    // MARK: - Fetch All Data
    func fetchAllData() {
        fetchBodyMassIndex()
        fetchHeight()
        
        fetchCurrentDayActiveEnergyBurned()
        fetchLastWeekActiveEnergyBurned()
        
        fetchCurrentDayWalkingRunningDistance()
        fetchLastWeekWalkingRunningDistance()
        
        fetchCurrentDayExerciseMinutes()
        fetchLastWeekExerciseMinutes()
        
        fetchCurrentDayHeartRate()
        fetchLastWeekHeartRate()
        
        fetchCurrentDayOxygenSaturation()
        fetchLastWeekOxygenSaturation()
        
    }
}

