//  YogaExerciseGeneratorView.swift
import SwiftUI

struct YogaExerciseGeneratorView: View {
    @State private var bodyMassIndex: Double = 0.0
    @State private var heartRate: Double = 0.0
    @State private var height: Double = 0.0
    @State private var walkingRunningDistance: Double = 0.0
    @State private var activeEnergyBurned: Double = 0.0
    @State private var oxygenSaturation: Double = 0.0
    @State private var basalEnergyBurn: Double = 0.0
    @State private var exerciseMinutes: Double = 0.0
    @State private var standHours: Double = 0.0
    @State private var sleepAnalysis: Bool = false
    @State private var mindfulSession: Bool = false
    @State private var biologicalSex: String = ""
    @State private var dateOfBirth: Date = Date()
    
    var body: some View {
        
        Form {
            Section(header: Text("User Information")) {
                VStack {
                    TextField("Body Mass Index", value: $bodyMassIndex, format: .number)
                    
                    TextField("Heart Rate", value: $heartRate, format: .number)
                    TextField("Height", value: $height, format: .number)
                    TextField("Walking/Running Distance", value: $walkingRunningDistance, format: .number)
                    TextField("Active Energy Burned", value: $activeEnergyBurned, format: .number)
                    TextField("Oxygen Saturation", value: $oxygenSaturation, format: .number)
                    TextField("Basal Energy Burn", value: $basalEnergyBurn, format: .number)
                    TextField("Exercise Minutes", value: $exerciseMinutes, format: .number)
                    TextField("Stand Hours", value: $standHours, format: .number)
                    Toggle("Sleep Analysis", isOn: $sleepAnalysis)
                    Toggle("Mindful Session", isOn: $mindfulSession)
                    Picker("Biological Sex", selection: $biologicalSex) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                }
                
                
                Section {
                    Button("Generate Yoga Exercise") {
                        // Call your function with the provided parameters
                        let personalizedExercise = generateYogaExercise(
                            bodyMassIndex: bodyMassIndex,
                            heartRate: heartRate,
                            height: height,
                            walkingRunningDistance: walkingRunningDistance,
                            activeEnergyBurned: activeEnergyBurned,
                            oxygenSaturation: oxygenSaturation,
                            basalEnergyBurn: basalEnergyBurn,
                            exerciseMinutes: exerciseMinutes,
                            standHours: standHours,
                            sleepAnalysis: sleepAnalysis,
                            mindfulSession: mindfulSession,
                            biologicalSex: biologicalSex,
                            dateOfBirth: dateOfBirth
                        )
                        
                        // Do something with the personalized exercise
                        print(personalizedExercise)
                    }
                }
            }
        }
    }
    
    
    // Your function to generate personalized yoga exercise
    func generateYogaExercise(
        bodyMassIndex: Double,
        heartRate: Double,
        height: Double,
        walkingRunningDistance: Double,
        activeEnergyBurned: Double,
        oxygenSaturation: Double,
        basalEnergyBurn: Double,
        exerciseMinutes: Double,
        standHours: Double,
        sleepAnalysis: Bool,
        mindfulSession: Bool,
        biologicalSex: String,
        dateOfBirth: Date
    ) -> String {
        // Implement your logic to generate a personalized yoga exercise here
        // You can use the provided parameters to calculate the exercise
        // This is a simplified example, and you should replace it with your actual logic
        return "Here is your personalized yoga exercise: Do some stretching and deep breathing exercises."
    }
}

struct YogaExerciseGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        YogaExerciseGeneratorView()
    }
}
