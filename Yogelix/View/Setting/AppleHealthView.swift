//  AppleHealthView.swift
import SwiftUI
import HealthKit

struct AppleHealthView: View {
    @State private var isReadAccessGranted: Bool = false
    @State private var isWriteAccessGranted: Bool = false

    var body: some View {
        VStack {
            Text("Apple Health Permissions")
                .font(.title)
                .padding()

            Toggle("Grant Read Access", isOn: $isReadAccessGranted)
                .padding()


            Toggle("Grant Write Access", isOn: $isWriteAccessGranted)
                .padding()

            Button("Customize HealthKit Permissions") {
                // Trigger the HealthKit permissions popup
                showHealthKitPermissions()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .onAppear {
            // Initialize the state with current HealthKit permissions
            checkCurrentHealthKitPermissions()
        }
    }

    private func handleReadAccess(granted: Bool) {
        // Implement the logic to enable or disable read access
        // Call your existing HealthKit permission handling code
    }

    private func handleWriteAccess(granted: Bool) {
        // Implement the logic to enable or disable write access
        // Call your existing HealthKit permission handling code
    }

    private func showHealthKitPermissions() {
        // Call the function that triggers the HealthKit permissions popup
    }

    private func checkCurrentHealthKitPermissions() {
        // Check the current state of HealthKit permissions and update the toggles
        // You can use HealthKit APIs to check the current permissions status
    }
}

struct AppleHealthView_Previews: PreviewProvider {
    static var previews: some View {
        AppleHealthView()
    }
}
