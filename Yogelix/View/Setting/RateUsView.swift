//  RateUsView.swift
import SwiftUI

struct RateUsView: View {
    // Replace with your app's App Store ID
    private let appStoreID = "YOUR_APP_STORE_ID"

    var body: some View {
        VStack {
            Text("Enjoying the App?")
                .font(.title)
                .padding()

            Text("If you like our app, please take a moment to rate it on the App Store.")
                .padding()

            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appStoreID)") {
                Link("Rate Us on the App Store", destination: url)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            } else {
                Text("Unable to open App Store.")
            }
        }
        .padding()
    }
}

struct RateUsView_Previews: PreviewProvider {
    static var previews: some View {
        RateUsView()
    }
}
