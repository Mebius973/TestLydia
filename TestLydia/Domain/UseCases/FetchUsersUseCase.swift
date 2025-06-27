//
//  FetchUsersUseCase.swift
//  TestLydia
//
//  Created by Mebius on 26/06/2025.
//

import FactoryKit

protocol FetchUsersUseCase {
    func execute(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity)
}

final class FetchUsersUseCaseImpl: FetchUsersUseCase {
    @Injected(\.userRepository) private var userRepository: UserRepository

    func execute(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity) {
        return try await userRepository.fetchInitialUsers(batchSize: batchSize)
    }
}
