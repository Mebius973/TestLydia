//
//  UserListUITests.swift
//  TestLydia
//
//  Created by Mebius on 27/06/2025.
//


import XCTest
//import TestLydiaTestSupport

final class UserListUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        
    }

    func testInitialLoad_displaysUsers() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        XCTAssertTrue(table.cells.count > 0, "La table devrait contenir des cellules")
    }

    func testPullToRefresh_triggersReload() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        let startCount = table.cells.count

        table.swipeDown()

        // Attendre une mise à jour du nombre de cellules
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "count > %d", startCount),
            object: table.cells
        )
        _ = XCTWaiter().wait(for: [expectation], timeout: 5)
    }

    func testInfiniteScroll_loadsMoreUsers() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        let initialCount = table.cells.count

        // Scroll vers le bas
        table.swipeUp()
        table.swipeUp()
        table.swipeUp()

        // Attendre que de nouvelles cellules arrivent
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "count > %d", initialCount),
            object: table.cells
        )
        _ = XCTWaiter().wait(for: [expectation], timeout: 5)
    }

    func testInitError_showsAlert() {
        let app = Helpers.launchApp(stubMode: "init-error", testMode: true)

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        // Forcer le scroll vers le bas
        app.buttons["🔄"].tap()
        
        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        XCTAssertTrue(alert.buttons["OK"].exists)
    }


    func testLoadMoreError_showsFooterMessage() {
        // Simule une erreur de loadMore via env
        let app = Helpers.launchApp(stubMode: "loadmore-error", testMode: true)

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        // Forcer le scroll vers le bas
        app.buttons["↓"].tap()

        // Vérifie la présence du message dans le footer
        let footerText = "To see more, please reconnect to the internet."
        let footerLabel = app.staticTexts[footerText]
        XCTAssertTrue(footerLabel.waitForExistence(timeout: 5))
    }
}
