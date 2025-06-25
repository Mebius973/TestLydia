//
//  MockUserListCoordinator.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//
@testable import TestLydia

final class MockUserListCoordinator: UserListCoordinator {
    private(set) var showUserDetailCalled = false
    private(set) var userPassed: UserEntity?

    override func showUserDetail(user: UserEntity) {
        showUserDetailCalled = true
        userPassed = user
    }

    override func start() {
    }
}
