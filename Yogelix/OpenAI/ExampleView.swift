//  ExampleView.swift
import SwiftUI

struct ExampleView: View {
    @StateObject var networking = OpenAINetworking()
    @State private var prompt: String = ""
    @State private var responseText: String = ""
    
    var body: some View {
        VStack {
            TextField("Enter your prompt", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Send Prompt") {
                networking.fetchResponse(for: prompt) { result in
                    switch result {
                        case .success(let response):
                            // Assuming response has a property 'text' containing the actual response
                            self.responseText = response.prompt
                        case .failure(let error):
                            // Handle error
                            self.responseText = "Error: \(error.localizedDescription)"
                    }
                }
            }
            
            Text(responseText)
                .padding()
        }
    }
}

#Preview {
    ExampleView()
}
