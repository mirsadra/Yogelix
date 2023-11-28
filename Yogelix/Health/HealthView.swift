// HealthView.swift
import SwiftUI
import HealthKit
import Charts

struct HealthView: View {
    @ObservedObject var viewModel = HealthDataViewModel()
    @State private var selectedDay: UUID?
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    RingView(progress: CGFloat(viewModel.moveRingProgress), startColor: .red, endColor: .orange, labelText: "\(viewModel.activitySummary.activeEnergyBurned)", systemImageName: "flame.fill")
                    RingView(progress: CGFloat(viewModel.exerciseRingProgress), startColor: .green, endColor: .blue, labelText: "\(viewModel.activitySummary.appleExerciseTime)", systemImageName: "medal")
                    RingView(progress: CGFloat(viewModel.standRingProgress), startColor: .blue, endColor: .purple, labelText: "\(viewModel.activitySummary.appleStandHours)", systemImageName: "figure.stand")
                        .onAppear {
                            viewModel.fetchAllData()
                        }
                }
                .padding()
                VStack{
                    HStack {
                        MetricCardView(title: "Height", value: viewModel.heightReading ?? 0.0, unit: "cm", caption: "")
                        if let mostRecentBMI = viewModel.bodyMassIndexReadings?.first?.1 {
                            MetricCardView(title: "BMI", value: mostRecentBMI, unit: "", caption: "Latest Available Data", isInteger: false, iconName: "figure")
                        }
                    }
                    .padding()
                    
                    HStack {
                        // Last data submited for heart rate with date
                        if let mostRecentHR = viewModel.heartRateReadings?.first {
                            MetricCardView(title: "Heart Rate", value: mostRecentHR.1, unit: "bpm", date: mostRecentHR.0, caption: "Latest Available Data", iconName: "heart")
                        }
                        
                        // Active energy burn sum of day with date
                        if let readings = viewModel.activeEnergyBurnReadings {
                            let groupedReadings = Dictionary(grouping: readings, by: { Calendar.current.startOfDay(for: $0.0) })
                            let dailySums = groupedReadings.mapValues { readingsForDate in
                                readingsForDate.map { $0.1 }.reduce(0, +)
                            }

                            if let mostRecentDate = dailySums.keys.sorted(by: >).first {
                                let totalEnergyBurned = dailySums[mostRecentDate] ?? 0.0
                                MetricCardView(title: "Active Energy", value: totalEnergyBurned, unit: "kcal", date: mostRecentDate, caption: "Sum")
                            }
                        }
                    }
                    .padding()
                    
                    HStack {
                        // Active energy burn 
                        if let readings = viewModel.activeEnergyBurnReadings {
                            let endDate = Date()
                            let startDate = Calendar.current.date(byAdding: .day, value: -6, to: endDate)!

                            let filteredReadings = readings.filter { $0.0 >= startDate && $0.0 <= endDate }
                            let totalEnergyBurned = filteredReadings.map { $0.1 }.reduce(0, +)

                            let dateInterval = formatDateInterval(startDate: startDate, endDate: endDate)
                            MetricCardView(title: "Active Energy Burned (Last 7 Days)", value: totalEnergyBurned, unit: "kcal", caption: "Sum", dateInterval: dateInterval)
                        }
                    }
                    .padding()
                }
            }
        }
    }
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


