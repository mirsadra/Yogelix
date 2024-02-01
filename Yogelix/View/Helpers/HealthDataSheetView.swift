//
//  HealthDataSheetView.swift
//  Yogelix
//
//  Created by Mirsadra on 29/01/2024.
//

import SwiftUI




struct HealthDataSheetView: View {
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    
    var body: some View {
        VStack {
            HStack {
                if let bmiData = quantityViewModel.currentDayBMI {
                    MetricCard(isRefreshed: false, title: "BMI", value: bmiData.value, unit: "", date: bmiData.date, emoji: "🚹", caption: "")
                }
                
                if let heightData = quantityViewModel.height {
                    MetricCard(isRefreshed: false, title: "Height", value: heightData.value, unit: "cm", date: heightData.date, emoji: "🎚️", caption: "")
                }
            }
            .padding()
            
            HStack {
                if let activeEnergyData = quantityViewModel.currentDayActiveEnergyBurned {
                    MetricCard(isRefreshed: false, title: "Energy Burn", value: activeEnergyData.total, unit: "kcal", date: activeEnergyData.date, emoji: "🔥", caption: "caption")
                }
                
                
                if let walkRunData = quantityViewModel.currentDayWalkingRunningDistance {
                    MetricCard(isRefreshed: false, title: "Walk + Run Distance", value: walkRunData.value, unit: "m", date: walkRunData.date, emoji: "🏃🚶", caption: "caption")
                }
            }
            .padding()
        }
        .padding()
    }
}

struct HealthButton: View {
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    @State private var showHealthSheet = false
    
    var body: some View {
        NavigationStack {
            Button(action: {
                self.showHealthSheet = true
            }) {
                HStack {
                    Image(systemName: "heart.text.square.fill")
                        .imageScale(.large)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color.clear)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showHealthSheet) {
            HealthDataSheetView(quantityViewModel: _quantityViewModel)
        }
    }
}

#Preview {
    HealthDataSheetView()
        .environmentObject(QuantityDataViewModel())
}
