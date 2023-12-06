//  ManageSubscriptionView.swift
import SwiftUI

struct ManageSubscriptionView: View {
    // Placeholder data - replace with actual data and states
    @State private var currentSubscriptionTier = "Basic Plan"
    @State private var isSubscribed = true

    var body: some View {
        VStack {
            Text("Manage Your Subscription")
                .font(.title)
                .padding()

            if isSubscribed {
                Text("You are currently subscribed to the \(currentSubscriptionTier).")
                    .padding()

                // Option to change the subscription
                Button("Change Subscription Plan") {
                    // Implement change subscription logic
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                // Option to cancel the subscription
                Button("Cancel Subscription") {
                    // Implement cancel subscription logic
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            } else {
                Text("You are not currently subscribed to any plan.")
                    .padding()

                // Option to subscribe
                Button("Subscribe Now") {
                    // Implement subscribe logic
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct ManageSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ManageSubscriptionView()
    }
}
