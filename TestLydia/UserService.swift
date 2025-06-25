//
//  UserService.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import Foundation

class UserService {
    private let baseApiUrl = "https://randomuser.me/api/?results=10"
    
    func fetchUsers() async throws -> RandomUserResults {
    
        guard let url = URL(string: baseApiUrl) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
        return result
    }
        
}
