//
//  CoordinatorTests.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//


import XCTest
@testable import TestLydia
import UIKit

final class CoordinatorTests: XCTestCase {

    // MARK: - Mock Coordinator
    final class MockCoordinator: Coordinator {
        var navigationController: UINavigationController

        init() {
            self.navigationController = UINavigationController()
        }

        func start() {}
    }

    func testPushViewController() {
        // Given
        let coordinator = MockCoordinator()
        let vc = UIViewController()

        // When
        coordinator.push(vc)

        // Then
        XCTAssertEqual(coordinator.navigationController.viewControllers.count, 1)
        XCTAssertEqual(coordinator.navigationController.topViewController, vc)
    }

    func testPopViewController() {
        // Given
        let coordinator = MockCoordinator()
        let vc1 = UIViewController()
        let vc2 = UIViewController()
        coordinator.navigationController.viewControllers = [vc1, vc2]

        // When
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.navigationController.viewControllers.count, 1)
        XCTAssertEqual(coordinator.navigationController.topViewController, vc1)
    }
}
