//
//  UserDetailCoordinatorTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//


import XCTest
@testable import TestLydia
import UIKit

final class UserDetailCoordinatorTests: XCTestCase {
    func testStart_pushesUserDetailViewController() {
        // Given
        let user = UserEntity.mock(index: 0)
        let navController = UINavigationController()
        let coordinator = UserDetailCoordinator(user: user, navigationController: navController)

        // When
        coordinator.start()

        // Then
        let topVC = navController.topViewController
        XCTAssertTrue(topVC is UserDetailViewController)
    }

    func testBack_popsViewController() {
        // Given
        let rootVC = UIViewController()
        let user = UserEntity.mock(index: 0)
        let navController = UINavigationController(rootViewController: rootVC)
        let coordinator = UserDetailCoordinator(user: user, navigationController: navController)

        // Start pushes the detail VC
        coordinator.start()
        XCTAssertEqual(navController.viewControllers.count, 2)

        // When
        coordinator.back()

        // Then
        XCTAssertEqual(navController.viewControllers.count, 1)
        XCTAssertEqual(navController.topViewController, rootVC)
    }
}
