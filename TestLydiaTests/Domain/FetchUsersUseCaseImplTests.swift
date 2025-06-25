//
//  FetchUsersUseCaseImplTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//


import XCTest
import FactoryKit
@testable import TestLydia

final class FetchUsersUseCaseImplTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func test_execute_returnsMockedUsers() async throws {
        // Arrange
        let mockRepo = MockUserRepository()
        let expectedUsers = UserEntity.mocks(count: 3)
        mockRepo.users = expectedUsers
        Container.shared.userRepository.register { mockRepo }

        let useCase = FetchUsersUseCaseImpl()

        // Act
        let result = try await useCase.execute(batchSize: 3)

        // Assert
        XCTAssertEqual(result, expectedUsers)
        XCTAssertEqual(mockRepo.batchSize, 3)
    }

    func test_execute_throwsError_whenRepositoryFails() async {
        // Arrange
        enum FakeError: Error, Equatable { case fail }
        let mockRepo = MockUserRepository()
        mockRepo.errorToThrow = FakeError.fail
        Container.shared.userRepository.register { mockRepo }

        let useCase = FetchUsersUseCaseImpl()

        // Act & Assert
        do {
            _ = try await useCase.execute(batchSize: 5)
            XCTFail("Expected error was not thrown")
        } catch let error as FakeError {
            XCTAssertEqual(error, .fail)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
