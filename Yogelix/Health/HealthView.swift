// HealthView.swift
import SwiftUI
import HealthKit
import Charts

struct HealthView: View {
    @ObservedObject var viewModel = HealthDataViewModel()
    @State private var selectedDay: UUID?
    @State private var selectedTimePeriod: TimePeriod = .today
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    RingView(progress: CGFloat(viewModel.moveRingProgress), startColor: .red, endColor: .orange, labelText: "\(viewModel.activitySummary.activeEnergyBurned)", systemImageName: "flame.fill", imageColor: .red)
                    RingView(progress: CGFloat(viewModel.exerciseRingProgress), startColor: .green, endColor: .blue, labelText: "\(viewModel.activitySummary.appleExerciseTime)", systemImageName: "medal", imageColor: .yellow)
                    RingView(progress: CGFloat(viewModel.standRingProgress), startColor: .blue, endColor: .purple, labelText: "\(viewModel.activitySummary.appleStandHours)", systemImageName: "figure.stand")
                }
                .padding()
                VStack{
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            if let mostRecentBMI = viewModel.bodyMassIndexReadings?.first {
                                MetricCardView(title: "BMI", value: mostRecentBMI.1, unit: "", date: mostRecentBMI.0, caption: "Latest", iconName: "list.clipboard")
                            }
                            
                            if let mostRecentHeight = viewModel.heightReading {
                                MetricCardView(title: "Height", value: mostRecentHeight, unit: "cm", date: Date(), caption: "Latest", iconName: "pencil.and.ruler")
                            }
                            
                            if let mostRecentHR = viewModel.heartRateReadings?.first {
                                MetricCardView(title: "Heart Rate", value: mostRecentHR.1, unit: "bpm", date: mostRecentHR.0, caption: "Latest", iconName: "heart")
                            }
                        }
                        .padding()
                    }
                    
                    // Picker for selecting the time period
                    Picker("Time Period", selection: $selectedTimePeriod) {
                        Text("Today").tag(TimePeriod.today)
                        Text("Last 7 Days").tag(TimePeriod.last7Days)
                        Text("Last 30 Days").tag(TimePeriod.last30Days)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    HStack {
                        // Conditional display of MetricCardView based on selectedTimePeriod
                        if let activeEnergyBurnSum = viewModel.activeEnergyBurnReadings {
                            switch selectedTimePeriod {
                                case .today:
                                    let (dailyTotal, date) = viewModel.getDailyTotal(readings: activeEnergyBurnSum)
                                    MetricCardView(title: "⚡️ + 🔥", value: dailyTotal, unit: "kcal", date: date, caption: "∑")
                                    
                                case .last7Days:
                                    let (weeklyTotal, startDate, endDate) = viewModel.getWeeklyTotal(readings: activeEnergyBurnSum)
                                    let weeklyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "⚡️ + 🔥", value: weeklyTotal, unit: "kcal", caption: "∑", dateInterval: weeklyDateInterval)
                                    
                                case .last30Days:
                                    let (monthlyTotal, startDate, endDate) = viewModel.getMonthlyTotal(readings: activeEnergyBurnSum)
                                    let monthlyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "⚡️ + 🔥", value: monthlyTotal, unit: "kcal", caption: "∑", dateInterval: monthlyDateInterval)
                            }
                        }
                        
                        if let activeEnergyBurnAverage = viewModel.activeEnergyBurnReadings {
                            switch selectedTimePeriod {
                                case .today:
                                    let (dailyTotal, date) = viewModel.getDailyAverage(readings: activeEnergyBurnAverage)
                                    MetricCardView(title: "⚡️ + 🔥", value: dailyTotal, unit: "kcal", date: date, caption: "⨏")
                                    
                                case .last7Days:
                                    let (weeklyTotal, startDate, endDate) = viewModel.getWeeklyAverage(readings: activeEnergyBurnAverage)
                                    let weeklyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "⚡️ + 🔥", value: weeklyTotal, unit: "kcal", caption: "⨏", dateInterval: weeklyDateInterval)
                                    
                                case .last30Days:
                                    let (monthlyTotal, startDate, endDate) = viewModel.getMonthlyAverage(readings: activeEnergyBurnAverage)
                                    let monthlyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "⚡️ + 🔥", value: monthlyTotal, unit: "kcal", caption: "⨏", dateInterval: monthlyDateInterval)
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        // Conditional display of MetricCardView based on selectedTimePeriod
                        if let walkingRunningDistanceSum = viewModel.walkingRunningDistanceReadings {
                            switch selectedTimePeriod {
                                case .today:
                                    let (dailyTotal, date) = viewModel.getDailyDistanceTotal(readings: walkingRunningDistanceSum)
                                    MetricCardView(title: "🏃🏾 + 🚶🏼‍♀️", value: dailyTotal, unit: "km", date: date, caption: "∑", useTwoDecimalPlaces: true)
                                    
                                case .last7Days:
                                    let (weeklyTotal, startDate, endDate) = viewModel.getWeeklyDistanceTotal(readings: walkingRunningDistanceSum)
                                    let weeklyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "🏃🏾 + 🚶🏼‍♀️", value: weeklyTotal, unit: "km", caption: "∑", dateInterval: weeklyDateInterval, useTwoDecimalPlaces: true)
                                    
                                case .last30Days:
                                    let (monthlyTotal, startDate, endDate) = viewModel.getMonthlyDistanceTotal(readings: walkingRunningDistanceSum)
                                    let monthlyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "🏃🏾 + 🚶🏼‍♀️", value: monthlyTotal, unit: "km", caption: "∑", dateInterval: monthlyDateInterval, useTwoDecimalPlaces: true)
                            }
                        }
                        
                        if let walkingRunningDistanceAverage = viewModel.walkingRunningDistanceReadings {
                            switch selectedTimePeriod {
                                case .today:
                                    let (dailyTotal, date) = viewModel.getDailyDistanceAverage(readings: walkingRunningDistanceAverage)
                                    MetricCardView(title: "🏃🏾 + 🚶🏼‍♀️", value: dailyTotal, unit: "km", date: date, caption: "⨏", useTwoDecimalPlaces: true)
                                    
                                case .last7Days:
                                    let (weeklyTotal, startDate, endDate) = viewModel.getWeeklyDistanceAverage(readings: walkingRunningDistanceAverage)
                                    let weeklyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "🏃🏾 + 🚶🏼‍♀️", value: weeklyTotal, unit: "km", caption: "⨏", dateInterval: weeklyDateInterval, useTwoDecimalPlaces: true)
                                    
                                case .last30Days:
                                    let (monthlyTotal, startDate, endDate) = viewModel.getMonthlyDistanceAverage(readings: walkingRunningDistanceAverage)
                                    let monthlyDateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                                    MetricCardView(title: "🏃🏾 + 🚶🏼‍♀️", value: monthlyTotal, unit: "km", caption: "⨏", dateInterval: monthlyDateInterval, useTwoDecimalPlaces: true)
                            }
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchAllData()
        }
    }
}

enum TimePeriod {
    case today, last7Days, last30Days
}

func formatDateInterval(startDate: Date, endDate: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    let formattedStartDate = dateFormatter.string(from: startDate)
    let formattedEndDate = dateFormatter.string(from: endDate)
    return "\(formattedStartDate) - \(formattedEndDate)"
}


struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}


/*
 HStack {
 MetricCardView(title: "Height", value: viewModel.heightReading ?? 0.0, unit: "cm", caption: "")
 if let mostRecentBMI = viewModel.bodyMassIndexReadings?.first?.1 {
 MetricCardView(title: "BMI", value: mostRecentBMI, unit: "", caption: "Latest Available Data", isInteger: false, iconName: "figure")
 }
 }
 .padding()
 
 */
