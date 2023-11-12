//  CardView.swift
import SwiftUI

struct CardView: View {
    let exercise: DailyExercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Spacer()
            HStack {
                Label("\(exercise.steps.count)", systemImage: "figure.step.training")
                    .accessibilityLabel("\(exercise.steps.count) steps")
                Spacer()
                Label("\(exercise.lengthInMin)", systemImage: "timer")
                    .accessibilityLabel("\(exercise.lengthInMin) minute exercise")
                    .labelStyle(.trailingIcon)
            }
            .font(.subheadline)
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct CardView_Previews: PreviewProvider {
    static var exercise = DailyExercise.sampleExercises[0]
    static var previews: some View {
        CardView(exercise: exercise)
            .background(exercise.theme.mainColor)
            .previewLayout(.fixed(width: 200, height: 240))
            .presentationCornerRadius(16)
    }
}

