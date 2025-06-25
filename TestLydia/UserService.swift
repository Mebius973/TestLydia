//
//  UserService.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import Foundation

class UserService {
    private let baseApiUrl = "https://randomuser.me/api/"
    
    func fetchUsers(batchSize: Int) async throws -> RandomUserResults {
    
        guard let url = URL(string: formatUrl(batchSize: batchSize)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
        return result
    }
     
    func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> RandomUserResults {
    
        guard let url = URL(string: baseApiUrl) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
        return result
    }
    
    private func formatUrl(batchSize: Int, seed: String? = nil, page: Int? = nil) -> String {
        var result = "\(baseApiUrl)?results=\(batchSize)"
        if let seed = seed {
            result += "&seed=\(seed)"
        }
        
        if let page = page {
            result += "&page=\(page)"
        }
        
        return result
    }
}
