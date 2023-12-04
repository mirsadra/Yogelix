//  DailyExerciseView.swift
import SwiftUI

struct DailyExerciseView: View {
    let practices: [DailyPractice]
    
    var body: some View {
        NavigationStack {
            List(practices) { practices in
                NavigationLink(destination: DetailView(exercise: practices)) {
                    CardView(practices: practices)
                }
//                        .listRowBackground(practices.theme.mainColor)
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
        DailyExerciseView(practices: DailyPractice.dailyPractices)
    }
}
