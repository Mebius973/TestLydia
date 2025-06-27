//
//  MockUserRepository.swift
//  TestLydia
//
//  Created by Mebius on 27/06/2025.
//


import Foundation
@testable import TestLydia

public final class MockUserRepository: UserRepository {
    var simulateInitialError = false
    var simulateLoadMoreError = false
    var simulateRefreshError = false

    var users: [UserEntity] = []
    var paginationInfo = PaginationInfoEntity(seed: "mock-seed",
                                              results: 20,
                                              page: 1)

    public func fetchInitialUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
        if simulateInitialError {
            throw NSError(domain: "initError", code: 0)
        }
        return (users, paginationInfo)
    }

    public func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
        if simulateLoadMoreError {
            throw NSError(domain: "loadMoreError", code: 0)
        }
        return (users, paginationInfo)
    }

    public func fetchNewUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
        if simulateRefreshError {
            throw NSError(domain: "refreshError", code: 0)
        }
        return (users, paginationInfo)
    }
}
