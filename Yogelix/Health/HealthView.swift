// HealthView.swift
import SwiftUI
import HealthKit
import Charts

struct HealthView: View {
    @ObservedObject var viewModel = HealthDataViewModel()

    @State private var walkingRunningDistance: Double = 5.0 // in kilometers
    @State private var activeEnergyBurned: Double = 500.0 // in calories
    @State private var sleepAnalysis: Double = 8.0 // in hours
    @State private var mindfulSession: Double = 30.0 // in minutes
    @State private var selectedDay: UUID?
    
    
    struct Day: Identifiable {
        let id = UUID()
        let dayOfWeek: String
        let number: Int
    }
    
    // Create an array of days for the week
    let days: [Day] = [
        Day(dayOfWeek: "Sun", number: 66),
        Day(dayOfWeek: "Mon", number: 63),
        Day(dayOfWeek: "Tue", number: 62),
        Day(dayOfWeek: "Wed", number: 59),
        Day(dayOfWeek: "Thu", number: 63),
        Day(dayOfWeek: "Fri", number: 67),
        Day(dayOfWeek: "Sat", number: 63)
    ]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 26, height: 26)
                Text("Today")
                Spacer()
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 26, height: 26)
            }
            .padding()
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 15) {
                        ForEach(days) { day in
                            VStack {
                                Text(day.dayOfWeek)
                                    .font(.caption)
                                Text("\(day.number)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedDay == day.id ? .white : .blue)
                                    .padding()
                                    .background(selectedDay == day.id ? Color.blue : Color.clear)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedDay = day.id
                                    }
                            }
                        }
                    }
                }
                
                // Activity Rings View
                CustomActivityRingView(healthDataViewModel: viewModel)
                    .frame(height: 100)
                    .padding()
                
                Chart {
                    ForEach(viewModel.dailyAverageHeartRates, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Heart Rate", dataPoint.averageHeartRate)
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.day().month())
                    }
                }
                .chartYAxis {
                    AxisMarks() { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .navigationTitle("Heart Rate Trends")
                
                VStack() {
                    
                    if let bmi = viewModel.bodyMassIndex {
                        MetricCard(title: "Body Mass Index", value: bmi, unit: "", isInteger: false, iconName: "figure.arms.open")
                    } else {
                        Text("BMI data is not available.")
                    }
                    
                    if let hr = viewModel.heartRate {
                        MetricCard(title: "Heart Rate", value: hr, unit: "bpm")
                    } else {
                        Text("Heart rate data is not available")
                    }
                    
                    if let hght = viewModel.heightCm {
                        MetricCard(title: "Height", value: hght, unit: "cm")
                    } else {
                        Text("Height data is not available")
                    }
                    
                    MetricCard(title: "Sleep Analysis", value: sleepAnalysis, unit: "hrs")
                    MetricCard(title: "Mindful Session", value: mindfulSession, unit: "mins")
                }
                .padding()
            }
            .navigationTitle("Health Metrics")
        }
        .onAppear {
            viewModel.fetchAllData()
        }
    }
}

struct MetricCard: View {
    var title: String
    var value: Double
    var unit: String
    var isInteger: Bool = true  // default is set to true
    var iconName: String  = "figure" // default is set to figure
    
    var formattedValue: String {
        isInteger ? "\(Int(value))" : String(format: "%.2f", value)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("\(formattedValue) \(unit)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            }
            Spacer()
            Image(systemName: iconName)  // Use the iconName here
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 5))
    }
}


struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}


