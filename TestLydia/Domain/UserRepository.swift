//
//  UserRepository.swift
//  TestLydia
//
//  Created by Mebius on 26/06/2025.
//

protocol UserRepository {
    func fetchInitialUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity)
    func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity)
    func fetchNewUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntity)
}
