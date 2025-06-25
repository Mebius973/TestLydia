//
//  MockUserRepository.swift
//  TestLydia
//
//  Created by David Geoffroy on 27/06/2025.
//


import Foundation
@testable import TestLydia

public final class MockUserRepository: UserRepository {
    var errorToThrow: Error?

    var users: [UserEntity] = []
    private(set) var batchSize: Int = 0

    public func fetchInitialUsers(batchSize: Int) async throws -> [UserEntity] {
        if let errorToThrow {
            throw errorToThrow
        }
        
        self.batchSize = batchSize
        return users
    }

    public func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> [UserEntity] {
        if let errorToThrow {
            throw errorToThrow
        }
        
        self.batchSize = batchSize
        return users
    }

    public func fetchNewUsers(batchSize: Int) async throws -> [UserEntity] {
        if let errorToThrow {
            throw errorToThrow
        }
        
        self.batchSize = batchSize
        return users
    }
}
