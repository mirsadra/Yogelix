////
////  HealthDataView.swift
//import SwiftUI
//import Charts // Import the Apple Charts library
//
//struct LineChart: View {
//    
//    let data: [Double] // Replace with your actual data
//    let title: String
//    let legend: String
//    
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.title)
//                .padding()
//            
//            GeometryReader { geometry in
//                Path { path in
//                    let width = geometry.size.width
//                    let height = geometry.size.height
//                    let stepX = width / CGFloat(data.count - 1)
//                    let stepY = height / CGFloat(data.max() ?? 100)
//                    
//                    for (index, value) in data.enumerated() {
//                        let x = CGFloat(index) * stepX
//                        let y = height - CGFloat(value) * stepY
//                        if index == 0 {
//                            path.move(to: CGPoint(x: x, y: y))
//                        } else {
//                            path.addLine(to: CGPoint(x: x, y: y))
//                        }
//                    }
//                }
//                .stroke(Color.blue, lineWidth: 2)
//            }
//            .frame(height: 200)
//            .padding()
//            
//            Text(legend)
//                .font(.subheadline)
//        }
//    }
//}
//
//struct HealthDataView: View {
//    @ObservedObject private var viewModel = HealthDataViewModel()
//    let heartRateData: [Double] = [80, 85, 90, 88, 92, 95, 88] // Replace with your actual data
//    
//    var body: some View {
//        VStack {
//            Text("Weekly Average Heart Rate")
//                .font(.title)
//                .padding()
//            
//            if let weeklyAverages = viewModel.weeklyHeartRateAverages {
//                ForEach(weeklyAverages, id: \.0) { date, averageHeartRate in
//                    Text("\(formattedDate(date)): \(averageHeartRate, specifier: "%.1f") bpm")
//                }
//            } else {
//                Text("Loading...")
//            }
//            
//            Button("Load Weekly Averages") {
//                viewModel.loadWeeklyHeartRateAverages()
//            }
//            .padding()
//            
//            // Add more charts or data visualization components here
//        }
//        .navigationTitle("Health Data")
//    }
//    
//    private func formattedDate(_ date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        return dateFormatter.string(from: date)
//    }
//}
//
//#Preview {
//    HealthDataView()
//}
