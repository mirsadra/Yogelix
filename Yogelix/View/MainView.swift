//  MainView.swift
import SwiftUI

struct MainView: View {
    @EnvironmentObject var quantityViewModel : QuantityDataViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
            VStack {
                UserTrophyToolbar()
                    .ignoresSafeArea()
                
                HStack {
                    if let activeEnergyData = quantityViewModel.currentDayActiveEnergyBurned {
                        MetricCard(isRefreshed: false, title: "Energy Burn", value: activeEnergyData.total, unit: "kcal", date: activeEnergyData.date, emoji: "🔥", caption: "caption")
                    }
                    
                    
                    if let walkRunData = quantityViewModel.currentDayWalkingRunningDistance {
                        MetricCard(isRefreshed: false, title: "Walk + Run Distance", value: walkRunData.value, unit: "m", date: walkRunData.date, emoji: "🏃🚶", caption: "caption")
                    }

                }
                .padding()
                    
                    HStack {
                        if let bmiData = quantityViewModel.currentDayBMI {
                            MetricCard(isRefreshed: false, title: "BMI", value: bmiData.value, unit: "", date: bmiData.date, emoji: "🚹", caption: "")
                                .padding()
                        }
                        
                        if let heightData = quantityViewModel.height {
                            MetricCard(isRefreshed: false, title: "Height", value: heightData.value, unit: "cm", date: heightData.date, emoji: "🎚️", caption: "")
                                .padding()
                        }
                    }
                .padding()
            }
    }
}
