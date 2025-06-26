//
//  UserRepositoryImpl.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    private let baseApiUrl = "https://randomuser.me/api/"
    
    func fetchUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntitiy) {
    
        guard let url = URL(string: formatUrl(batchSize: batchSize)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
        
        let users: [UserEntity] = try await extractEntities(from: result)

        return (users, result.info.asEntity())
    }
     
    func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntitiy) {
    
        guard let url = URL(string: baseApiUrl) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
        
        let users: [UserEntity] = try await extractEntities(from: result)

        return (users, result.info.asEntity())
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
    
    private func extractEntities(from result: RandomUserResults) async throws -> [UserEntity] {
        return try await withThrowingTaskGroup(of: UserEntity.self) { group in
            for user in result.users {
                group.addTask {
                    let rawImage = await self.getImage(user.picture.medium)
                    return user.asEntity(rawImage: rawImage)
                }
            }

            return try await group.reduce(into: [UserEntity]()) { $0.append($1) }
        }
    }
    
    private func getImage(_ url: String) async -> Data? {
        guard let url = URL(string: url) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            print("no Image")
            return nil
        }
    }
}
