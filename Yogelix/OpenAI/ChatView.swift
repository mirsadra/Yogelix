//  ChatView.swift
import SwiftUI

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
}

struct ChatView: View {
    @State private var prompt: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var showingError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading: Bool = false

    private let apiClient = OpenAIApiClient()

    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        ForEach(messages) { message in
                            HStack {
                                if message.isFromUser {
                                    Spacer()
                                }
                                
                                Text(message.content)
                                    .padding()
                                    .background(message.isFromUser ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: message.isFromUser ? .trailing : .leading)
                                
                                if !message.isFromUser {
                                    Spacer()
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .onChange(of: messages) {
                        // The action does not capture the new value of messages
                        // It only uses the fact that messages has changed to perform an action
                        scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
                
                HStack {
                    TextField("Enter your prompt", text: $prompt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Send") {
                            isLoading = true
                            fetchOpenAIResponse()
                        }
                        .disabled(prompt.isEmpty)
                    }
                }
                .padding()
            }
            .navigationTitle("OpenAI Chat")
            .alert(isPresented: $showingError) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func fetchOpenAIResponse() {
        apiClient.fetchResponse(for: prompt) { text, error in
            DispatchQueue.main.async {
                isLoading = false
                if let text = text {
                    messages.append(ChatMessage(content: "You: \(prompt)", isFromUser: true))
                    messages.append(ChatMessage(content: "Assistant: \(text)", isFromUser: false))
                    prompt = "" // Clear input field after getting the response
                } else if let error = error {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
