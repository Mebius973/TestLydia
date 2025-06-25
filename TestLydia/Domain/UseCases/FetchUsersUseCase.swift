//
//  FetchUsersUseCase.swift
//  TestLydia
//
//  Created by David Geoffroy on 26/06/2025.
//

import FactoryKit

protocol FetchUsersUseCase {
    func execute(batchSize: Int) async throws -> [UserEntity]
}

final class FetchUsersUseCaseImpl: FetchUsersUseCase {
    @Injected(\.userRepository) private var userRepository: UserRepository

    func execute(batchSize: Int) async throws -> [UserEntity] {
        return try await userRepository.fetchInitialUsers(batchSize: batchSize)
    }
}
