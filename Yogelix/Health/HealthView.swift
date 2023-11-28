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
                        MetricCardView(title: "Height", value: viewModel.heightReading ?? 0.0, unit: "cm" )
                        if let mostRecentBMI = viewModel.bodyMassIndexReadings?.first?.1 {
                            MetricCardView(title: "BMI", value: mostRecentBMI, unit: "", isInteger: false, iconName: "figure")
                        }
                    }
                    .padding()
                    
                    HStack {
                        if let mostRecentHR = viewModel.heartRateReadings?.first {
                            MetricCardView(title: "Heart Rate", value: mostRecentHR.1, unit: "bpm", date: mostRecentHR.0, iconName: "heart")
                        }
                        
                        if let readings = viewModel.activeEnergyBurnReadings {
                            let groupedReadings = Dictionary(grouping: readings, by: { Calendar.current.startOfDay(for: $0.0) })
                            let dailySums = groupedReadings.mapValues { readingsForDate in
                                readingsForDate.map { $0.1 }.reduce(0, +)
                            }

                            if let mostRecentDate = dailySums.keys.sorted(by: >).first {
                                let totalEnergyBurned = dailySums[mostRecentDate] ?? 0.0
                                MetricCardView(title: "Active Energy", value: totalEnergyBurned, unit: "kcal", date: mostRecentDate)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}


