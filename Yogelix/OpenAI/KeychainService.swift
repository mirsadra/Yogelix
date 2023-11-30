//  KeychainService.swift
import KeychainSwift

// MARK: - This class is responsible for storing and retrieving the API key using the Keychain.
class KeychainService {
    private let keychain = KeychainSwift()

    // Function to store the API key
    func storeApiKey() {
        let apiKey = "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"
        keychain.set(apiKey, forKey: "myAPIKey")
    }

    // Function to retrieve the API key
    func retrieveApiKey() -> String? {
        return keychain.get("myAPIKey")
    }
}
