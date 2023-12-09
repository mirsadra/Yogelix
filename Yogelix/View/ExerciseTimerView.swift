//  ExerciseView.swift
import SwiftUI

struct ExerciseTimerView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var poseViewModel : PoseViewModel
    
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
        }
        .padding()
    }
}

#Preview {
    ExerciseTimerView()
        .environmentObject(AuthenticationViewModel())
        .environmentObject(PoseViewModel())
}
