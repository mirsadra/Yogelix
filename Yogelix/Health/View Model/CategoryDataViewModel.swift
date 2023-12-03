//  CategoryDataViewModel.swift
import Foundation

class CategoryDataViewModel: ObservableObject {
    
    private var categoryTypeManager = CategoryTypeManager()
    
    // Properties to store the processed data for both current day and last week
    var currentDaySleepData: [SleepAnalysisModel] = []
    var lastWeekSleepData: [SleepAnalysisModel] = []
    var currentDayMindfulSessionsData: [MindfulSessionModel] = []
    var lastWeekMindfulSessionsData: [MindfulSessionModel] = []
    
    @Published var authorizationStatus: Bool = false
    @Published var error: Error?
    
    init() {
        requestAuthorization()
    }
    
    // MARK: - Authorization
    private func requestAuthorization() {
        categoryTypeManager.requestAuthorization { [weak self] success, error in
            DispatchQueue.main.async {
                self?.authorizationStatus = success
                if success {
                    // Fetch data only after successful authorization
                    self?.fetchAllData()
                } else {
                    self?.error = error
                }
            }
        }
    }
    
    // MARK: - Data Fetching Methods for Sleep Analysis
    func fetchCurrentDaySleepAnalysis(completion: @escaping (Error?) -> Void) {
        categoryTypeManager.readCurrentDaySleepAnalysis { [weak self] (data, error) in
            if let data = data {
                self?.currentDaySleepData = data
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    func fetchLastWeekSleepAnalysis(completion: @escaping (Error?) -> Void) {
        categoryTypeManager.readLastWeekSleepAnalysis { [weak self] (data, error) in
            if let data = data {
                self?.lastWeekSleepData = data
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    // MARK: - Data Fetching Methods for Mindful Sessions
    func fetchCurrentDayMindfulSessions(completion: @escaping (Error?) -> Void) {
        categoryTypeManager.readCurrentDayMindfulSessions { [weak self] (data, error) in
            if let data = data {
                self?.currentDayMindfulSessionsData = data
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    func fetchLastWeekMindfulSessions(completion: @escaping (Error?) -> Void) {
        categoryTypeManager.readLastWeekMindfulSessions { [weak self] (data, error) in
            if let data = data {
                self?.lastWeekMindfulSessionsData = data
                completion(nil)
            } else {
                completion(error)
            }
        }
    }
    
    // MARK: - Data Fetching Methods
    private func fetchAllData() {
        fetchCurrentDaySleepAnalysis { _ in }
        fetchLastWeekSleepAnalysis { _ in }
        fetchCurrentDayMindfulSessions { _ in }
        fetchLastWeekMindfulSessions { _ in }
    }
    
    // Additional ViewModel methods can be added here, such as data formatting for display
}
