//
//  UserRepository.swift
//  TestLydia
//
//  Created by Mebius on 26/06/2025.
//

protocol UserRepository {
    func fetchUsers(batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntitiy)
    func fetchNextUsers(seed: String, page: Int, batchSize: Int) async throws -> ([UserEntity], PaginationInfoEntitiy)
}
