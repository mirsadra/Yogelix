//  MainView.swift
import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = QuantityDataViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @StateObject var modelData = ModelData()
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                UserTrophyToolbar()
                    .ignoresSafeArea()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        
                        if let activeEnergyData = viewModel.currentDayActiveEnergyBurned {
                            HealthCard(isRefreshed: false, title: "Energy Burn", value: activeEnergyData.total, unit: "kcal", date: activeEnergyData.date, emoji: "🔥")
                                .padding()
                        }
                        
                        if let walkRunData = viewModel.currentDayWalkingRunningDistance {
                            HealthCard(isRefreshed: false, title: "Walk + Run Distance", value: walkRunData.value, unit: "m", date: walkRunData.date, emoji: "🏃🚶")
                                .padding()
                        }
                        
                        if let bmiData = viewModel.currentDayBMI {
                            HealthCard(isRefreshed: false, title: "BMI", value: bmiData.value, unit: "", date: bmiData.date, emoji: "🚹")
                                .padding()
                        }
                        
                        if let heightData = viewModel.height {
                            HealthCard(isRefreshed: false, title: "Height", value: heightData.value, unit: "cm", date: heightData.date, emoji: "🎚️")
                                .padding()
                        }
                        

                    }
                    .padding()
                }
                
                Spacer()
                
                if let userData = authViewModel.userData {
                    PoseOfTheDay(modelData: modelData, userData: userData)
                        .padding()
                }
            }
        }
        .navigationTitle("Main")
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthenticationViewModel())
    }
}
