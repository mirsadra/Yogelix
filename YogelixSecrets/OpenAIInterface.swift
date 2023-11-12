// OpenAIInterface.swift
/* import Foundation
 
 public class OpenAIInterface {
 public static let shared = OpenAIInterface()
 private let openAIService = OpenAIService.shared
 
 private init() {}
 
 public func fetchOpenAIResponse(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
 openAIService.fetchResponse(for: prompt) { result in
 switch result {
 case .success(let response):
 completion(.success(response))
 case .failure(let error):
 completion(.failure(error))
 }
 }
 }
 }
 */
