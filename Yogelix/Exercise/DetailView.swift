//  DetailView.swift
import SwiftUI

struct DetailView: View {
    var pose: Pose
    @State private var exerciseDuration: Double = 30  // Default duration value in seconds

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ... existing content ...

                // Circle Progress and Duration Picker
                VStack {
                    CircleProgressView(duration: $exerciseDuration)
                        .frame(width: 150, height: 150)
                        .padding()

                    // Slider to adjust the duration
                    Slider(value: $exerciseDuration, in: 0...120, step: 1) {
                        Text("Duration")
                    } minimumValueLabel: {
                        Text("0s")
                    } maximumValueLabel: {
                        Text("120s")
                    } onEditingChanged: { editing in
                        // Handle the start of editing
                    }
                }

                StartPracticeButton(pose: pose)
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Define the start practice button
    @ViewBuilder
    private func StartPracticeButton(pose: Pose) -> some View {
        Button(action: {
            // Handle the start practice action here
        }) {
            HStack {
                Image(systemName: "play.fill")
                Text("Start Practice")
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.top)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// CircleProgressView
struct CircleProgressView: View {
    @Binding var duration: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.duration / 120.0, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: duration)

            Text(String(format: "%.0f s", self.duration))
                .font(.title)
                .bold()
        }
    }
}

// Preview
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(pose: ModelData().poses[0])
        }
    }
}


/*
 import SwiftUI

 struct DetailView: View {
     var pose: Pose

     var body: some View {
         ScrollView {
             VStack(alignment: .leading, spacing: 20) {
                 Text("Pose Information")
                     .font(.title2)
                     .bold()
                     .padding(.top)

                 HStack {
                     Text("English Name:")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     Spacer()
                     Text(pose.englishName)
                         .font(.title3)
                 }

                 HStack {
                     Text("Sanskrit Name:")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     Spacer()
                     Text(pose.sanskritName)
                         .font(.title3)
                 }

                 HStack {
                     Text("Difficulty:")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     Spacer()
                     Text(String(repeating: "★", count: pose.difficulty))
                         .foregroundColor(.yellow)
                 }

                 VStack(alignment: .leading) {
                     Text("Benefits:")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     ForEach(pose.poseBenefits, id: \.self) { benefit in
                         Text("• " + benefit)
                     }
                 }

                 VStack(alignment: .leading) {
                     Text("Precautions:")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     ForEach(pose.posePrecautions, id: \.self) { precaution in
                         Text("• " + precaution)
                     }
                 }

                 VStack(alignment: .leading) {
                     Text("Related Chakras:")
                         .font(.headline)
                         .foregroundColor(.secondary)
                     // Assuming you have a method to display chakras, replace `Text` with your chakra view.
                     Text("Chakra representations go here")
                 }

                 StartPracticeButton(pose: pose)
             }
             .padding()
         }
         .navigationTitle("Detail")
         .navigationBarTitleDisplayMode(.inline)
     }

     // Define the start practice button
     @ViewBuilder
     private func StartPracticeButton(pose: Pose) -> some View {
         Button(action: {
             // Handle the start practice action here
         }) {
             HStack {
                 Image(systemName: "play.fill")
                 Text("Start Practice")
             }
             .font(.headline)
             .foregroundColor(.white)
             .padding()
             .background(Color.blue)
             .cornerRadius(8)
         }
         .padding(.top)
         .frame(maxWidth: .infinity, alignment: .center)
     }
 }

 // Preview
 struct DetailView_Previews: PreviewProvider {
     static var previews: some View {
         NavigationView {
             DetailView(pose: ModelData().poses[0])
         }
     }
 }

 */
