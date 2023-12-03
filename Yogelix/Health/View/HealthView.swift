// HealthView.swift
import SwiftUI
import HealthKit
import Charts

struct HealthView: View {
    @ObservedObject var quantityViewModel = QuantityDataViewModel()
    @ObservedObject var categoryViewModel = CategoryDataViewModel()
    @ObservedObject var workoutViewModel = WorkoutDataViewModel()

    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ScrollView(.horizontal, showsIndicators: true) {
                        HStack {
                            if let bmiData = quantityViewModel.currentDayBMI {
                                
                                MetricCardView(
                                    title: "BMI",
                                    emoji: "❤️",
                                    value: bmiData.value,
                                    unit: "", // assuming you don't have a unit for BMI
                                    date: bmiData.date,
                                    caption: "Latest"
                                )
                            }

                        }
                        .padding()
                    }
                    
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
    
    
    /*
     HStack {
     MetricCardView(title: "Height", value: viewModel.heightReading ?? 0.0, unit: "cm", caption: "")
     if let mostRecentBMI = viewModel.bodyMassIndexReadings?.first?.1 {
     MetricCardView(title: "BMI", value: mostRecentBMI, unit: "", caption: "Latest Available Data", isInteger: false, iconName: "figure")
     }
     }
     .padding()
     
     */
