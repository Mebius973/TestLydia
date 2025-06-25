//
//  CacheManager.swift
//  TestLydia
//
//  Created by David Geoffroy on 27/06/2025.
//

import Foundation

class CacheManager: CacheManagerProtocol {
    
    private struct Constants {
        static let usersCacheKey = "cachedUsers"
    }
    
    // MARK: - Public Methods
    func loadFromCache() -> [UserEntity]? {
        guard let rawUsers = UserDefaults.standard.data(forKey: Constants.usersCacheKey),
              let cachedUsers = try? JSONDecoder().decode([UserEntity].self, from: rawUsers) else {
            return nil
        }
        return cachedUsers
    }
    
    func saveUsersToCache(_ users: [UserEntity]) {
        var cachedUsers = getUsersFromCacheUnsafe()
        cachedUsers.append(contentsOf: users)
        
        guard let rawUsers = try? JSONEncoder().encode(cachedUsers) else { return }
        UserDefaults.standard.set(rawUsers, forKey: Constants.usersCacheKey)
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: Constants.usersCacheKey)
    }
    
    // MARK: - Private Methods
    private func getUsersFromCacheUnsafe() -> [UserEntity] {
        guard let rawUsers = UserDefaults.standard.data(forKey: Constants.usersCacheKey),
              let cachedUsers = try? JSONDecoder().decode([UserEntity].self, from: rawUsers) else {
            return []
        }
        return cachedUsers
    }
}
