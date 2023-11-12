//  AIFeaturedWorkoutView.swift
import SwiftUI

struct DailyWorkoutView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Workout")
                .font(.headline)
                .padding(.bottom, 4)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                
                
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Button(action: {
                // Action to start the workout
            }) {
                Text("Start Workout")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
        .onAppear {
            
        }
    }
}

#Preview {
    DailyWorkoutView()
}
