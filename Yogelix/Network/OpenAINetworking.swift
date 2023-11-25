//  OpenAINetworking.swift
import Foundation
import Alamofire

class OpenAINetworking: ObservableObject {
    
    @Published var responseText: String = ""
    
    func sendRequest() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer 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", //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  (0.57$)
            "Content-Type": "application/json"
        ]
        
        let messages: [[String: Any]] = [
            [
                "role": "system",
                "content": "You are a helpful assistant that provides a personalized yoga routine as a JSON object based on the provided health metrics such as heart rate, steps, sleep quality, mindfulness minutes, weight, height, and abdominal cramps."
            ],
            [
                "role": "user",
                "content": "Generate a 30-45 minutes personalized Yoga plan based on my following data: I am 30 year-old, average heart rate 100 bpm, 72 kg weight, 180 cm height. The plan should start with warmup and finish with cooldown."
            ]
        ]
        
        // JSON Body
        let body: [String: Any] = [
                "model": "gpt-4-1106-preview",
                "temperature": 0.5,
                "messages": messages
            ]
        
        AF.request("https://api.openai.com/v1/chat/completions",
                   method: .post,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: CompletionResponse.self) { [weak self] response in
            
            guard let statusCode = response.response?.statusCode else {
                print("Failed to get HTTP status code.")
                return
            }
            switch response.result {
                case .success(let completionResponse):
                    if let firstChoiceText = completionResponse.choices.first?.message.content, !firstChoiceText.isEmpty {
                        DispatchQueue.main.async {
                            self?.responseText = firstChoiceText
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.responseText = "Received empty text from the API."
                        }
                    }
                    
                case .failure(let error):
                    if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorRootResponse.self, from: data) {
                        // Print the custom error message from the API
                        print("API Error Message: \(errorResponse.error.message)")
                        DispatchQueue.main.async {
                            self?.responseText = "API Error: \(errorResponse.error.message)"
                        }
                    } else {
                        // Print the error from Alamofire
                        print("Alamofire Error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            self?.responseText = "Received error with status code \(statusCode): \(error.localizedDescription)"
                        }
                    }
                    
            }
        }
    }
    
}

//  ChatGPTAPIModels.swift
import Foundation

enum ChatGPTModel: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case gpt4Turbo = "gpt-4-1106-preview"
    
    var text: String {
        switch self {
            case .gpt4Turbo:
                return "GPT-4 Turbo"
        }
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

extension Array where Element == Message {
    var contentCount: Int { reduce(0, { $0 + $1.content.count })}
}

struct Request: Codable {
    let model: String
    let temperature: Double
    let messages: [Message]
    let stream: Bool
}

struct ErrorRootResponse: Decodable {
    let error: ErrorResponse
}

struct ErrorResponse: Decodable {
    let message: String
    let type: String?
}

struct StreamCompletionResponse: Decodable {
    let choices: [StreamChoice]
}

struct CompletionResponse: Decodable {
    let choices: [Choice]
    let usage: Usage?
}

struct Usage: Decodable {
    let promptTokens: Int?
    let completionTokens: Int?
    let totalTokens: Int?
}

struct Choice: Decodable {
    let message: Message
    let finishReason: String?
}

struct StreamChoice: Decodable {
    let finishReason: String?
    let delta: StreamMessage
}

struct StreamMessage: Decodable {
    let role: String?
    let content: String?
}
