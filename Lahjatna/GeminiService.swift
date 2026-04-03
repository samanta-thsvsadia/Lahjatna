
//
//  GeminiService.swift
//  lahjtna
//
//  Created by Sadia Thasina on 07/10/2025.
//

import Foundation

// MARK: - Models
struct GeminiMessage: Codable {
    let role: String?
    let parts: [GeminiPart]?
}

struct GeminiPart: Codable {
    let text: String?
}

struct GeminiResponse: Codable {
    let candidates: [Candidate]?
    
    struct Candidate: Codable {
        let content: GeminiMessage?
    }
}

struct GeminiError: Codable {
    struct ErrorDetail: Codable {
        let code: Int?
        let message: String?
    }
    let error: ErrorDetail?
}

// MARK: - Service
class GeminiService {
    private let apiKey = "xxxx"
    private let baseURL = "xxxxt"

    
    func sendMessage(_ text: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            completion("Invalid URL")
            return
        }
        
        let message = GeminiMessage(role: "user", parts: [GeminiPart(text: text)])
        let body = ["contents": [message]]
        
        guard let jsonData = try? JSONEncoder().encode(body) else {
            completion("Failed to encode message")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Network error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion("No data received from Gemini")
                }
                return
            }
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON: \(jsonString)")
            }
            
            // Try decoding as normal response
            if let response = try? JSONDecoder().decode(GeminiResponse.self, from: data),
               let text = response.candidates?.first?.content?.parts?.first?.text {
                DispatchQueue.main.async {
                    completion(text)
                }
                return
            }
            
            // Try decoding as error response
            if let apiError = try? JSONDecoder().decode(GeminiError.self, from: data),
               let message = apiError.error?.message {
                DispatchQueue.main.async {
                    completion("API Error: \(message)")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion("Unexpected response from Gemini 😕")
            }
        }.resume()
    }
}
