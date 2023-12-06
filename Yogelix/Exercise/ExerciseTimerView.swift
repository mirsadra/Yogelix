//  ExerciseView.swift
import SwiftUI

struct ExerciseTimerView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel // Ensure this is provided in the environment
    @StateObject var modelData = ModelData() // This can also be passed in if shared across views
    
    
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
            
            Circle()
                .strokeBorder(lineWidth: 14)
            HStack {
                Text("Pose of the Day")
                    .font(.title3)
                    .bold()
                Button(action: { }) {
                    Image(systemName: "rosette")
                }
            }
            // Conditionally display PoseOfTheDay
            if let userData = authViewModel.userData {
                PoseOfTheDay(modelData: modelData, userData: userData)
            } else {
                Text("Please sign in to view the Pose of the Day.")
            }
        }
        .padding()
    }
}

#Preview {
    ExerciseTimerView()
        .environmentObject(AuthenticationViewModel())
}
