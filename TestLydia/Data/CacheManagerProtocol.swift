//
//  CacheManagerProtocol.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//

protocol CacheManagerProtocol {
    func loadFromCache() -> [UserEntity]?
    func saveUsersToCache(_ users: [UserEntity])
    func clearCache()
}
