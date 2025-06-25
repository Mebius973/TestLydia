//
//  FetchNextUsersUseCase.swift
//  TestLydia
//
//  Created by David Geoffroy on 26/06/2025.
//

import FactoryKit

protocol FetchNextUsersUseCase {
    func execute(batchSize: Int) async throws -> [UserEntity]
}

final class FetchNextUsersUseCaseImpl: FetchNextUsersUseCase {
    @Injected(\.userRepository) private var userRepository: UserRepository

    func execute(batchSize: Int) async throws -> [UserEntity] {
        return try await userRepository.fetchNewUsers(batchSize: batchSize)
    }
}
