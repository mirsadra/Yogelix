//  OpenAIApiClient.swift
import Foundation

class OpenAIApiClient {
    func fetchResponse(for prompt: String, completion: @escaping (String?, Error?) -> Void) {
        // API Call implementation
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")  // Replace with your API Key
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the Request Body
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",  // Correct model identifier
            "messages": [
                ["role": "system", "content": "Your role is as a yoga instructor, tasked with creating daily, individualized yoga routines based on specific user requirements."],
                ["role": "user", "content": "I need a yoga routine tailored to my needs. It should be 30-45 minutes long. I am 30 years old with an average heart rate of 100 bpm. My weight is 72 kg, and I am 180 cm tall. Please include a warm-up and a cooldown. The focus should be on improving cardiac health. Can you provide a detailed, step-by-step guide for each part of the routine that caters to my health and fitness objectives?"],
                ["role": "assistant", "content": "Certainly! Let's create a yoga routine that suits your specific needs, focusing on cardiac health. We'll structure it with an initial warm-up, followed by the main exercise segment, and conclude with a cooldown. Each part will be detailed to match your fitness level and goals."]
                // Add all previous messages in the conversation here
            ],
            "max_tokens": 400
        ]
        
        let requestBody = try? JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = requestBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content, nil)
                } else {
                    let rawResponse = String(data: data, encoding: .utf8) ?? "Could not decode data"
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unexpected response format: \(rawResponse)"]))
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}


