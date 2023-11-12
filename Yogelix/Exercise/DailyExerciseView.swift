//  DailyExerciseView.swift
import SwiftUI

struct DailyExerciseView: View {
    let exercise: [DailyExercise]
    
    var body: some View {
        NavigationStack {
            List(exercise) { exercise in
                NavigationLink(destination: DetailView(exercise: exercise)) {
                    CardView(exercise: exercise)
                }
                        .listRowBackground(exercise.theme.mainColor)
            }
            .navigationTitle("Daily Exercise")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                }
                .accessibilityLabel("New Exercise")
            }
        }
    }
}

struct DailyExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        DailyExerciseView(exercise: DailyExercise.sampleExercises)
    }
}
