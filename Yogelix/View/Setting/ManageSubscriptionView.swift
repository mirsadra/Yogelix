//  ManageSubscriptionView.swift
import SwiftUI
import StoreKit

struct ManageSubscriptionView: View {
    @State private var isPresentingSubscriptionView = false

    var body: some View {
        VStack {
            // Your additional UI components here
            
            Button("Subscribe Now") {
                isPresentingSubscriptionView = true
            }
            .sheet(isPresented: $isPresentingSubscriptionView) {
                // Present the SubscriptionStoreView here
                SubscriptionStoreView(groupID: "21421494")
                    // Customize the SubscriptionStoreView appearance here
                    .subscriptionStoreControlBackground(.gradientMaterial)
                    .subscriptionStoreControlStyle(.buttons)
            }
        }
    }
}

struct ManageSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ManageSubscriptionView()
    }
}
