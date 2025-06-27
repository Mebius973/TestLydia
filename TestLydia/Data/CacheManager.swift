//
//  CacheManager.swift
//  TestLydia
//
//  Created by Mebius on 27/06/2025.
//
import Foundation

class CacheManager {
    private struct K {
        static let usersCacheKey = "cachedUsers"
    }
    
    static func loadFromCache() -> [UserEntity]? {
        guard let rawUsers = UserDefaults.standard.data(forKey: K.usersCacheKey),
              let cachedUsers = try? JSONDecoder().decode([UserEntity].self, from: rawUsers) else { return nil }
        return cachedUsers
     }

    static func saveUsersToCache(_ users: [UserEntity]) {
        var cachedUsers = getUsersFromCache()
            cachedUsers.append(contentsOf: users)
         guard let rawUsers = try? JSONEncoder().encode(cachedUsers) else { return }
        UserDefaults.standard.set(rawUsers, forKey: K.usersCacheKey)
     }
    
    private static func getUsersFromCache() -> [UserEntity] {
        guard let rawUsers = UserDefaults.standard.data(forKey: K.usersCacheKey),
              let cachedUsers = try? JSONDecoder().decode([UserEntity].self, from: rawUsers) else { return []}
        return cachedUsers
    }
}
