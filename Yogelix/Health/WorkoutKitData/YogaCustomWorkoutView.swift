//  YogaCustomWorkoutView.swift
import SwiftUI
import WorkoutKit

struct YogaCustomWorkoutView: View {
    private let yogaWorkoutPlan: WorkoutPlan
    @State var show: Bool = false
    
    init() {
        yogaWorkoutPlan = WorkoutPlan(.custom(WorkoutStore.createYogaCustomWorkout()))
    }
    
    var body: some View {
        Button("Present Yoga Workout Preview") {
            show.toggle()
        }
        .workoutPreview(yogaWorkoutPlan, isPresented: $show)
    }
}

#Preview {
    YogaCustomWorkoutView()
}
