//
//  FetchNextUsersUseCase.swift
//  TestLydia
//
//  Created by Mebius on 26/06/2025.
//

import FactoryKit

protocol FetchNextUsersUseCase {
    func execute(batchSize: Int, currentPage: Int, paginationInfo: PaginationInfoEntitiy?) async throws -> ([UserEntity], PaginationInfoEntitiy)
}

final class FetchNextUsersUseCaseImpl: FetchNextUsersUseCase {
    @Injected(\.userRepository) private var userRepository: UserRepository

    func execute(batchSize: Int, currentPage: Int, paginationInfo: PaginationInfoEntitiy?) async throws -> ([UserEntity], PaginationInfoEntitiy) {
        if let paginationInfo, currentPage < paginationInfo.page {
            return try await userRepository.fetchNextUsers(seed: paginationInfo.seed, page: paginationInfo.page, batchSize: batchSize)
        } else {
            return try await userRepository.fetchNewUsers(batchSize: batchSize)
        }
    }
}
