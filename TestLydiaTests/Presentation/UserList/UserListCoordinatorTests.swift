//
//  UserListCoordinatorTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//


import XCTest
import FactoryKit
@testable import TestLydia

final class UserListCoordinatorTests: XCTestCase {
    var mockFetchUsersUseCase: MockFetchUsersUseCase!
    var mockFetchNextUsersUseCase: MockFetchNextUsersUseCase!
    
    override func setUp() {
        super.setUp()
        
        mockFetchUsersUseCase = MockFetchUsersUseCase()
        mockFetchNextUsersUseCase = MockFetchNextUsersUseCase()

        Container.shared.fetchUsersUseCase.register { self.mockFetchUsersUseCase }
        Container.shared.fetchNextUsersUseCase.register { self.mockFetchNextUsersUseCase }

    }
    
    func testStart_pushesUserListViewController() {
        // Given
        let navController = UINavigationController()
        let coordinator = UserListCoordinator(navigationController: navController)
        
        // When
        coordinator.start()

        // Then
        let topVC = navController.topViewController
        XCTAssertTrue(topVC is UserListViewController)
    }
    
    func testShowUserDetail_pushesUserDetailViewController() {
        // Given
        let rootVC = UIViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        let coordinator = UserListCoordinator(navigationController: navController)
        XCTAssertEqual(navController.viewControllers.count, 1)
        let user = UserEntity.mock(index: 0)

        // When
        coordinator.showUserDetail(user: user)

        // Then
        XCTAssertEqual(navController.viewControllers.count, 2)
        let pushedVC = navController.topViewController
        XCTAssertTrue(pushedVC is UserDetailViewController)
    }
}
