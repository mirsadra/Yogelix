//  YogaInstructionView.swift
import SwiftUI
import FirebaseRemoteConfig
import FirebaseRemoteConfigSwift

struct YogaInstructionView: View {
    @RemoteConfigProperty(key: "stepsStyle", fallback: "square") var stepsStyle: String
    var yogaPose: YogaPose
    
    // Later, yogaPose should be modified to the steps of exercise.
    var body: some View {
        List {
            Section {
                ForEach(yogaPose.poseMeta.indices, id: \.self) { index in
                    Label(yogaPose.poseMeta[index], systemImage: "\(index + 1).\(stepsStyle)")
                }
            } header: {
                HStack {
                    Text("Instructions")
                        .font(.title)
                    Spacer()
                    Text("\(yogaPose.poseMeta.count) pose")
                }
            }
        }
        .listRowSeparator(.hidden)
        .listStyle(.plain)
        .onAppear {
            RemoteConfig.remoteConfig().fetchAndActivate()
        }
    }
}

#Preview {
    YogaInstructionView(yogaPose: samplePose)
}
