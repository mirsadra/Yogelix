//  ExerciseView.swift
import SwiftUI

struct ExerciseTimerView: View {
    var body: some View {
        VStack {
            ProgressView(value: 5, total: 15)
            HStack {
                VStack(alignment: .leading) {
                    Text("Seconds Elapsed")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.tophalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Seconds Remaining")
                        .font(.caption)
                    Label("600", systemImage: "hourglass.bottomhalf.fill")
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Time remaining")
            .accessibilityValue("10 minutes")
            Circle()
                .strokeBorder(lineWidth: 14)
            HStack {
                Text("Exercise Title")
                    .font(.title3)
                    .bold()
                Button(action: { }) {
                    Image(systemName: "rosette")
                }
                .accessibilityLabel("Next Step Button")
            }
        }
        .padding()
    }
}

#Preview {
    ExerciseTimerView()
}
