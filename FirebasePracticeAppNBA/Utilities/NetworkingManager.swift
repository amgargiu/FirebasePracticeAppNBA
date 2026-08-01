//
//  NetworkingManager.swift
//  FirebasePracticeAppNBA
//
//  Created by Antonio Gargiulo on 7/30/26.
//

import Foundation


final class NetworkingManager {
    
    static let shared = NetworkingManager()
    private init() {}
    
    func getData<T: Decodable>(url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}


