//  DetailView.swift
import SwiftUI

struct DetailView: View {
    let exercise: DailyExercise
    
    var body: some View {
        List {
            Section(header: Text("Exercise Info")) {
                Label("Start Exercise", systemImage: "timer")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text("\(exercise.lengthInMin) minutes")
                }
                .accessibilityElement(children: .combine)
                HStack {
                    Label("Theme", systemImage: "paintpalette") // var name: String in `Theme.swift`
                    Spacer()
                    Text(exercise.theme.name)
                        .padding(4)
                        .foregroundColor(exercise.theme.accentColor)
                        .background(exercise.theme.mainColor)
                    
                }
                .accessibilityElement(children: .combine)
            }
            Section(header: Text("Steps")) {
                ForEach(exercise.steps) { steps in
                    Label(steps.name, systemImage: "flag.2.crossed")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(exercise: DailyExercise.sampleExercises[0])
    }
}
