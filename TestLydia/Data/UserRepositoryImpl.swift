//
//  UserRepositoryImpl.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    private var baseApiUrl: URL? {
        #if DEBUG
        if let custom = ProcessInfo.processInfo.environment["API_BASE_URL"],
           let url = URL(string: custom) {
            return url
        }
        #endif
        return URL(string: "https://randomuser.me/api/")
        
    }
    
    private let imageCache = NSCache<NSString, NSData>()
    
    func fetchInitialUsers(batchSize: Int) async throws -> [UserEntity] {
        try await fetchUsers(batchSize: batchSize, useCache: true)
    }
    
    func fetchNewUsers(batchSize: Int) async throws -> [UserEntity] {
       try await fetchUsers(batchSize: batchSize, useCache: false)
    }
    
    private func fetchUsers(batchSize: Int, useCache: Bool) async throws -> [UserEntity] {
        do {
            let url = try makeApiURL(batchSize: batchSize)
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(RandomUserResults.self, from: data)
            
            let users: [UserEntity] = try await extractEntities(from: result)

            CacheManager.saveUsersToCache(users)
            
            return users
        } catch {
            guard useCache,
                  let cachedUsers = CacheManager.loadFromCache() else { throw error }
            return cachedUsers
        }
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
    
    private func makeApiURL(batchSize: Int) throws -> URL {
        guard let baseApiUrl else {
            throw URLError(.badURL)
        }
        var components = URLComponents(url: baseApiUrl, resolvingAgainstBaseURL: false)!
        
        // Ajoute ou remplace les query items existants
        var queryItems = components.queryItems ?? []
        queryItems.append(URLQueryItem(name: "results", value: "\(batchSize)"))
        components.queryItems = queryItems

        return components.url!
    }
}
