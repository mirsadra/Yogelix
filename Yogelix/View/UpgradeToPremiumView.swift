//  UpgradeToPremiumView.swift
import SwiftUI

struct UpgradeToPremiumView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Get More with Premium")
                .font(.headline)
                .padding(.bottom, 5)
            
            Text("Unlock all the features and content to accelerate your yoga journey.")
                .padding(.bottom, 20)
            
            // List out the benefits
            ForEach(0..<3, id: \.self) { _ in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Exclusive content and features")
                }
                .padding(.vertical, 2)
            }
            
            Spacer()
            
            // Call to Action for Upgrading
            Button(action: {
                // Action to upgrade to premium
            }) {
                Text("Go Premium")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
        }
        .padding()
        .navigationTitle("Upgrade to Premium")
    }
}

#Preview {
    UpgradeToPremiumView()
}
