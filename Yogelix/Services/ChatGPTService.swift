//  ChatGPTService.swift
import Foundation

class ChatGPTService {
    private let apiKey = ""
    private let session = URLSession.shared
    private let url = URL(string: "https://api.openai.com/v1/engines/davinci/completions")!
    
    func generatePlan(age: Int, gender: String, weight: Int, height: Int, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "Generate a personalized exercise plan for a \(age)-year-old \(gender) with a weight of \(weight) kg and height of \(height) cm."
        let body: [String: Any] = [
            "prompt": prompt,
            "max_tokens": 1024
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let responseDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = responseDictionary["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let text = firstChoice["text"] as? String else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            completion(.success(text))
        }
        
        task.resume()
    }
}


