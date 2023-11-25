//  AIFeaturedWorkoutView.swift
import SwiftUI

struct DailyWorkoutView: View {
    
    @ObservedObject var openAINetworking = OpenAINetworking()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack {
                Text(openAINetworking.responseText) // Display the response text
                    .padding()
                
                Spacer()
                
                Button("Send Request") {
                    // Call the sendRequest method when the button is tapped
                    openAINetworking.sendRequest()
                }
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    DailyWorkoutView()
}
