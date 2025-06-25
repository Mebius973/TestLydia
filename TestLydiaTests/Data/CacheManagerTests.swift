//
//  CacheManagerTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//

import XCTest
@testable import TestLydia

final class CacheManagerTests: XCTestCase {
    private let cacheManager = CacheManager()
        
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        // Nettoyer le cache avant chaque test
        cacheManager.clearCache()
    }
    
    override func tearDown() {
        // Nettoyer le cache après chaque test
        cacheManager.clearCache()
        super.tearDown()
    }
    
    // MARK: - loadFromCache Tests
    
    func testLoadFromCache_WhenCacheIsEmpty_ReturnsNil() {
        // Given
        // Cache is empty (cleared in setUp)
        
        // When
        let result = cacheManager.loadFromCache()
        
        // Then
        XCTAssertNil(result)
    }
    
    func testLoadFromCache_WhenCacheHasValidData_ReturnsUsers() {
        // Given
        let testUsers = UserEntity.mocks()
        cacheManager.saveUsersToCache(testUsers)
        
        // When
        let result = cacheManager.loadFromCache()
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, 3)
        XCTAssertEqual(result?.first?.firstName, "firstName0")
        XCTAssertEqual(result?.first?.lastName, "lastName0")
    }
    
    func testLoadFromCache_WhenCacheHasInvalidData_ReturnsNil() {
        // Given
        let invalidData = "invalid json data".data(using: .utf8)!
        UserDefaults.standard.set(invalidData, forKey: "cachedUsers")
        
        // When
        let result = cacheManager.loadFromCache()
        
        // Then
        XCTAssertNil(result)
    }
    
    // MARK: - saveUsersToCache Tests
    
    func testSaveUsersToCache_WhenCacheIsEmpty_SavesUsers() {
        // Given
        let testUsers = UserEntity.mocks()
        
        // When
        cacheManager.saveUsersToCache(testUsers)
        
        // Then
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(cachedUsers?.count, 3)
        XCTAssertEqual(cachedUsers?.first?.firstName, "firstName0")
    }
    
    func testSaveUsersToCache_WhenCacheHasExistingData_AppendsUsers() {
        // Given
        let initialUsers = [UserEntity.mock(index: 2)]
        cacheManager.saveUsersToCache(initialUsers)
        
        let newUsers = [UserEntity.mock(index: 20)]
        
        // When
        cacheManager.saveUsersToCache(newUsers)
        
        // Then
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(cachedUsers?.count, 2)
        XCTAssertEqual(cachedUsers?.first?.firstName, "firstName2")
        XCTAssertEqual(cachedUsers?.last?.firstName, "firstName20")
    }
    
    func testSaveUsersToCache_WithEmptyArray_DoesNotChangeCache() {
        // Given
        let initialUsers = UserEntity.mocks()
        cacheManager.saveUsersToCache(initialUsers)
        
        // When
        cacheManager.saveUsersToCache([])
        
        // Then
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(cachedUsers?.count, 3) // Still has original users
    }
    
    func testSaveUsersToCache_WithDuplicateUsers_AppendsDuplicates() {
        // Given
        cacheManager.clearCache() // Ensure cache is empty
        let testUser = UserEntity.mock(index: 1)
        cacheManager.saveUsersToCache([testUser])
        
        // When
        cacheManager.saveUsersToCache([testUser]) // Save same user again
        
        // Then
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(cachedUsers?.count, 2) // Should have 2 identical users
        XCTAssertEqual(cachedUsers?.first?.firstName, "firstName1")
        XCTAssertEqual(cachedUsers?.last?.firstName, "firstName1")
    }
    
    // MARK: - clearCache Tests
    
    func testClearCache_WhenCacheHasData_ClearsCache() {
        // Given
        let testUsers = UserEntity.mocks()
        cacheManager.saveUsersToCache(testUsers)
        
        // Verify cache has data
        XCTAssertNotNil(cacheManager.loadFromCache())
        
        // When
        cacheManager.clearCache()
        
        // Then
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNil(cachedUsers)
    }
    
    func testClearCache_WhenCacheIsEmpty_DoesNotCrash() {
        // Given
        // Cache is already empty
        
        // When & Then
        XCTAssertNoThrow(cacheManager.clearCache())
        
        // Verify cache is still empty
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNil(cachedUsers)
    }
    
    // MARK: - Integration Tests
    
    func testCacheWorkflow_SaveLoadClear() {
        // Given
        let testUsers = UserEntity.mocks()
        
        // When - Save users
        cacheManager.saveUsersToCache(testUsers)
        
        // Then - Verify save worked
        var cachedUsers = cacheManager.loadFromCache()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(cachedUsers?.count, 3)
        
        // When - Add more users
        let additionalUsers = [UserEntity.mock(index: 5)]
        cacheManager.saveUsersToCache(additionalUsers)
        
        // Then - Verify append worked
        cachedUsers = cacheManager.loadFromCache()
        XCTAssertEqual(cachedUsers?.count, 4)
        XCTAssertEqual(cachedUsers?.last?.firstName, "firstName5")
        
        // When - Clear cache
        cacheManager.clearCache()
        
        // Then - Verify clear worked
        cachedUsers = cacheManager.loadFromCache()
        XCTAssertNil(cachedUsers)
    }
    
    // MARK: - Performance Tests
    
    func testSaveUsersToCache_Performance() {
        // Given
        let largeUserArray = (1...1000).map {
            UserEntity.mock(index: $0)
        }
        
        // When & Then
        measure {
            cacheManager.saveUsersToCache(largeUserArray)
        }
    }
    
    func testLoadFromCache_Performance() {
        // Given
        let largeUserArray = (1...1000).map {
            UserEntity.mock(index: $0)
        }
        cacheManager.saveUsersToCache(largeUserArray)
        
        // When & Then
        measure {
            _ = cacheManager.loadFromCache()
        }
    }
    
    // MARK: - Edge Cases
    
    func testSaveUsersToCache_WithNilOptionalProperties_HandlesGracefully() {
        // Given
        let testUser = UserEntity.mock(index: 1)
        // Si UserEntity a des propriétés optionnelles, les tester avec nil
        
        // When
        cacheManager.saveUsersToCache([testUser])
        
        // Then
        let cachedUsers = cacheManager.loadFromCache()
        XCTAssertNotNil(cachedUsers)
        XCTAssertEqual(cachedUsers?.count, 1)
    }
}
