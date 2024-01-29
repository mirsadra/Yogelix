//  MainView.swift
import SwiftUI

struct MainView: View {
    @EnvironmentObject var quantityViewModel: QuantityDataViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showHealthSheet = false // State to manage sheet presentation

    private func greeting() -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return currentHour < 12 ? "Good Morning" : currentHour < 17 ? "Good Afternoon" : "Good Evening"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    // User Profile and Greeting
                    HStack {
                        ProfileButton()
                            .frame(width: 40, height: 40)
                        VStack(alignment: .leading) {
                            Text("\(greeting()),")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Welcome, \(authViewModel.displayName) ❤️")
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
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
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Dashboard")
            .sheet(isPresented: $showHealthSheet) {
                HealthDataSheetView(quantityViewModel: _quantityViewModel)
            }
        }
    }
}

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



struct SessionView: View {
    var duration: String
    var focusArea: MetadataCategory
    var pose: Pose
    
    var body: some View {
        HStack {
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
                .imageScale(.large)
            VStack(alignment: .leading) {
                Text("Yoga Session")
                    .fontWeight(.semibold)
                ForEach(pose.metadata, id: \.self) { category in
                    Text(category.rawValue)
                        .foregroundStyle(.secondary)
                        .bold()
                }
            }
            Spacer()
            Text("")
        }
    }
}
