//
//  UserRepositoryImpl.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    private let baseApiUrl = "https://randomuser.me/api/"
    private let imageCache = NSCache<NSString, NSData>()
    
    func fetchInitialUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
        try await fetchUsers(batchSize: batchSize, useCache: true)
    }
    
    func fetchNewUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
       try await fetchUsers(batchSize: batchSize, useCache: false)
    }
     
    func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
    
        guard let url = URL(string: formatUrl(batchSize: batchSize, seed: seed, page: page)) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
        
        let users: [UserEntity] = try await extractEntities(from: result)

        return (users, result.info.asEntity())
    }
    
    private func fetchUsers(batchSize: Int, useCache: Bool) async throws -> ([UserEntity], PaginationInfoEntity) {
        do {
            guard let url = URL(string: formatUrl(batchSize: batchSize)) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
            
            let users: [UserEntity] = try await extractEntities(from: result)
            let pagination = result.info.asEntity()
            
            CacheManager.saveUsersToCache(users, pagination: pagination)
            
            return (users, pagination)
        } catch {
            guard useCache,
                  let (cachedUsers, cachedPagination) = CacheManager.loadFromCache() else { throw error }
            return (cachedUsers, cachedPagination)
        }
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
    
    private func getImage(_ urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            if let imageData = imageCache.object(forKey: urlString as NSString) {
                return Data(referencing: imageData)
            } else {
                let (data, _) = try await URLSession.shared.data(from: url)
                imageCache.setObject(data as NSData, forKey: urlString as NSString)
                return data
            }
        } catch {
            print("no Image")
            return nil
        }
    }
}
