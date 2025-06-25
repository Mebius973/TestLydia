//
//  MockFetchUsersUseCase.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//
@testable import TestLydia

class MockFetchUsersUseCase: FetchUsersUseCase {
    var usersToReturn: [UserEntity] = []
    var errorToThrow: Error?

    func execute(batchSize: Int) async throws -> [UserEntity] {
        if let error = errorToThrow {
            throw error
        }
        return usersToReturn
    }
}
