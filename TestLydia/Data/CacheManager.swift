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
        static let paginationCacheKey = "cachedPagination"
    }
    
    static func loadFromCache() -> ([UserEntity], PaginationInfoEntitiy)? {
        guard let rawUsers = UserDefaults.standard.data(forKey: K.usersCacheKey),
              let rawPagination = UserDefaults.standard.data(forKey: K.paginationCacheKey),
              let cachedUsers = try? JSONDecoder().decode([UserEntity].self, from: rawUsers),
              let cachedPagination = try? JSONDecoder().decode(PaginationInfoEntitiy.self, from: rawPagination) else { return nil }
        return (cachedUsers, cachedPagination)
     }

    static func saveUsersToCache(_ users: [UserEntity], pagination: PaginationInfoEntitiy) {
        var cachedUsers = getUsersFromCache()
            cachedUsers.append(contentsOf: users)
         guard let rawUsers = try? JSONEncoder().encode(cachedUsers),
               let rawPagination = try? JSONEncoder().encode(pagination) else { return }
        UserDefaults.standard.set(rawUsers, forKey: K.usersCacheKey)
        UserDefaults.standard.set(rawPagination, forKey: K.paginationCacheKey)
     }
    
    private static func getUsersFromCache() -> [UserEntity] {
        guard let rawUsers = UserDefaults.standard.data(forKey: K.usersCacheKey),
              let cachedUsers = try? JSONDecoder().decode([UserEntity].self, from: rawUsers) else { return []}
        return cachedUsers
    }
}
