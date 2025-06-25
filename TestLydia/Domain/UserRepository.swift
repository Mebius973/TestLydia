//
//  UserRepository.swift
//  TestLydia
//
//  Created by David Geoffroy on 26/06/2025.
//

protocol UserRepository {
    func fetchInitialUsers(batchSize: Int) async throws -> [UserEntity]
    func fetchNewUsers(batchSize: Int) async throws -> [UserEntity]
}
