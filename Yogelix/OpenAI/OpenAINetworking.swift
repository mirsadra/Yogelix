//  OpenAINetworking.swift
import Foundation
import Alamofire

class OpenAINetworking: ObservableObject {
    private let keychainService = KeychainService()
    
    func fetchResponse(for prompt: String, completion: @escaping (Result<OpenAIResponse, Error>) -> Void) {
        guard let apiKey = keychainService.retrieveApiKey() else {
            completion(.failure(NetworkError.missingApiKey))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "prompt": prompt,
            // Add other parameters as needed
        ]
        
        AF.request("https://api.openai.com/v1/chat/completions",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: OpenAIResponse.self) { response in
            switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
        
    }
}

enum NetworkError: Error {
    case missingApiKey
    // Define other error cases as needed
}

struct OpenAIResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [ResponseChoice]
    let prompt: String // The original prompt that generated the response

    // Include other fields as per OpenAI's response

    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
    }

    struct ResponseChoice: Codable {
        let message: ResponseMessage
        let finishReason: String
        let index: Int
    }

    struct ResponseMessage: Codable {
        let role: String
        let content: String
    }

    // Include other fields specific to the response, as needed
}

