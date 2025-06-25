//
//  MockCacheManager.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//
@testable import TestLydia

class MockCacheManager: CacheManagerProtocol {
    var clearCacheCalled = false
    var saveUsersToCache_called = false
    var loadFromCache_called = false
    var loadFromCache_returnValue: [UserEntity]?
    
    func clearCache() {
        // Mock implementation
        clearCacheCalled = true
    }
    
    func saveUsersToCache(_ users: [UserEntity]) {
        // Mock implementation
        saveUsersToCache_called = true
    }
    
    func loadFromCache() -> [UserEntity]? {
        // Mock implementation
        loadFromCache_called = true
        return loadFromCache_returnValue
    }
}
