// NetworkManager.swift
import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()
    private let session = URLSession.shared

    public func performRequest<T: Codable>(url: URL, method: String, body: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                let rawResponseString = String(data: data, encoding: .utf8)
                print("Raw response:", rawResponseString ?? "No raw data 😔")

                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    print("Decoding error:", error)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

public struct OpenAIRequest: Codable {
    let prompt: String
    let maxTokens: Int
}

public struct OpenAIResponse: Codable {
    let id: String
    let choices: [Choice]
}

public struct Choice: Codable {
    let text: String
}

// MARK: - OpenAIService

public class OpenAIService {
    public static let shared = OpenAIService()
    private var apiKey: String {
        Secrets.openAIKey
    }

    public func fetchResponse(from data: [String: Any], for prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let openAIRequest = OpenAIRequest(prompt: prompt, maxTokens: 150)
        guard let requestData = try? JSONEncoder().encode(openAIRequest) else { return }

        let endpoint = "https://api.openai.com/v1/engines/text-davinci-002/completions"
        guard let url = URL(string: endpoint) else { return }

        // Since the apiKey is a sensitive piece of information, make sure it's securely managed
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        NetworkManager.shared.performRequest(url: url, method: "POST", body: requestData) { (result: Result<OpenAIResponse, Error>) in
            switch result {
            case .success(let response):
                // Assuming the response contains the desired text in the first choice
                completion(.success(response.choices.first?.text ?? ""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
