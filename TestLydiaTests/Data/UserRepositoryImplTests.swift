//
//  UserRepositoryImplTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//


import XCTest
import Foundation
import FactoryKit
@testable import TestLydia

class UserRepositoryImplTests: XCTestCase {
    
    var sut: UserRepositoryImpl!
    var mockURLSession: MockURLSession!
    var mockCacheManager: MockCacheManager!
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = MockURLSession()
        mockCacheManager = MockCacheManager()
        Container.shared.urlSession.register { self.mockURLSession }
        Container.shared.cacheManager.register { self.mockCacheManager }
        
        sut = UserRepositoryImpl()
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        mockCacheManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests fetchInitialUsers
    
    func testFetchInitialUsers_Success() async throws {
        // Given
        let batchSize = 10
        let mockUsers = UserEntity.mocks(count: batchSize)
        let mockResponse = RandomUserResults(users: mockUsers.map { User($0) }, info: Info.mock(batchSize))
        let mockData = try JSONEncoder().encode(mockResponse)
        
        // Mock URLSession response
        mockURLSession.data = mockData
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://randomuser.me/api/")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        // When
        let result = try await sut.fetchInitialUsers(batchSize: batchSize)
        
        // Then
        XCTAssertEqual(result.count, batchSize)
        XCTAssertTrue(mockCacheManager.clearCacheCalled)
        XCTAssertTrue(mockCacheManager.saveUsersToCache_called)
    }
    
    func testFetchInitialUsers_NetworkFailure_ReturnsCachedUsers() async throws {
        // Given
        let batchSize = 10
        let cachedUsers = UserEntity.mocks(count: 5)
        mockCacheManager.loadFromCache_returnValue = cachedUsers
        mockURLSession.error = URLError(.networkConnectionLost)
        
        // When
        let result = try await sut.fetchInitialUsers(batchSize: batchSize)
        
        // Then
        XCTAssertEqual(result.count, cachedUsers.count)
        XCTAssertTrue(mockCacheManager.loadFromCache_called)
    }
    
    func testFetchInitialUsers_NetworkFailure_NoCachedUsers_ThrowsError() async {
        // Given
        let batchSize = 10
        mockCacheManager.loadFromCache_returnValue = nil
        mockURLSession.error = URLError(.networkConnectionLost)
        
        // When & Then
        do {
            _ = try await sut.fetchInitialUsers(batchSize: batchSize)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    // MARK: - Tests fetchNewUsers
    
    func testFetchNewUsers_Success() async throws {
        // Given
        let batchSize = 5
        let mockUsers = UserEntity.mocks(count: batchSize)
        let mockResponse = RandomUserResults(users: mockUsers.map { User($0) }, info: Info.mock(batchSize))
        let mockData = try JSONEncoder().encode(mockResponse)
        
        mockURLSession.data = mockData
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://randomuser.me/api/")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        // When
        let result = try await sut.fetchNewUsers(batchSize: batchSize)
        
        // Then
        XCTAssertEqual(result.count, batchSize)
        XCTAssertFalse(mockCacheManager.clearCacheCalled) // Ne doit pas être appelé pour fetchNewUsers
    }
    
    func testFetchNewUsers_NetworkFailure_ThrowsError() async {
        // Given
        let batchSize = 5
        mockURLSession.error = URLError(.networkConnectionLost)
        
        // When & Then
        do {
            _ = try await sut.fetchNewUsers(batchSize: batchSize)
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    // MARK: - Tests d'intégration
    
    func testFetchUsers_WithImageDownload_Success() async throws {
        // Given
        let batchSize = 2
        let mockUsers = UserEntity.mocks(count: batchSize)
        let mockResponse = RandomUserResults(users: mockUsers.map { User($0) }, info: Info.mock(batchSize))
        let mockData = try JSONEncoder().encode(mockResponse)
        
        mockURLSession.data = mockData
        mockURLSession.response = HTTPURLResponse(url: URL(string: "https://randomuser.me/api/")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        
        // When
        let result = try await sut.fetchInitialUsers(batchSize: batchSize)
        
        // Then
        XCTAssertEqual(result.count, batchSize)
        // Vérifier que les images ont été téléchargées
        for user in result {
            XCTAssertNotNil(user.rawProfilePicture)
        }
    }
}
