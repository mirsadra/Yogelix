// HealthView.swift
import SwiftUI
import HealthKit

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
                                MetricCard(
                                    title: "BMI",
                                    emoji: "🚹",
                                    value: bmiData.value,
                                    unit: "", // assuming you don't have a unit for BMI
                                    date: bmiData.date,
                                    caption: "Latest"
                                )
                            }
                            
                            if let heightData = quantityViewModel.height {
                                MetricCard(
                                    title: "Height",
                                    emoji: "🎚️",
                                    value: heightData.value * 100,
                                    unit: "cm",
                                    date: heightData.date,
                                    caption: "Latest"
                                )
                            }
                            
                            if let activeEnergySumData = quantityViewModel.currentDayActiveEnergyBurned {
                                MetricCard(
                                    title: "Active Energy",
                                    emoji: "🔥",
                                    value: activeEnergySumData.total,
                                    unit: "kcal",
                                    date: activeEnergySumData.date,
                                    caption: "Latest"
                                )
                            }
                            
                            if let walkRunDistanceSumData = quantityViewModel.currentDayWalkingRunningDistance {
                                MetricCard(
                                    title: "Walk & Run Distance",
                                    emoji: "🏃🚶",
                                    value: walkRunDistanceSumData.value,
                                    unit: "m",
                                    date: walkRunDistanceSumData.date,
                                    caption: "Latest")
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
