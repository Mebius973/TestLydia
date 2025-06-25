//
//  FetchNextUsersUseCaseTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//


import XCTest
import FactoryKit
@testable import TestLydia

final class FetchNextUsersUseCaseTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset l'injection pour chaque test
        Container.shared.reset()
    }

    func test_execute_returnsUsersFromRepository() async throws {
        // Arrange
        let mockRepo = MockUserRepository()
        let expectedUsers = [UserEntity.mock(index: 1)]
        mockRepo.users = expectedUsers
        Container.shared.userRepository.register { mockRepo }

        let useCase = FetchNextUsersUseCaseImpl()

        // Act
        let result = try await useCase.execute(batchSize: 5)

        // Assert
        XCTAssertEqual(result, expectedUsers)
        XCTAssertEqual(mockRepo.batchSize, 5)
    }

    func test_execute_throwsError_whenRepositoryFails() async {
        // Arrange
        enum TestError: Error { case failed }

        let mockRepo = MockUserRepository()
        mockRepo.errorToThrow = TestError.failed
        Container.shared.userRepository.register { mockRepo }

        let useCase = FetchNextUsersUseCaseImpl()

        // Act & Assert
        do {
            _ = try await useCase.execute(batchSize: 10)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, .failed)
        }
    }
}
