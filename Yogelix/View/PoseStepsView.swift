// PoseStepsView.swift
import SwiftUI

struct PoseStepsView: View {
    let pose: Pose

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Steps for \(pose.englishName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                ForEach(pose.steps, id: \.self) { step in
                    VStack(alignment: .leading) {
                        Text(step.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.bottom, 2)
                        
                        Text(step.description)
                            .padding(.bottom, 10)
                    }
                    .padding(.all, 10)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
            }
            .padding()
        }
        .navigationBarTitle("Pose Steps", displayMode: .inline)
    }
}
