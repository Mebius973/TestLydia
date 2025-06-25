//
//  UserListUITests.swift
//  TestLydia
//
//  Created by David Geoffroy on 27/06/2025.
//


import XCTest

final class UserListUITests: XCTestCase {
    let timeout: TimeInterval = 5.0
    
    override func setUp() {
        continueAfterFailure = false
    }

    func testInitialLoad_displaysUsers() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: timeout))
        XCTAssertTrue(table.cells.count > 0, "La table devrait contenir des cellules")
    }

    func testPullToRefresh_triggersReload() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: timeout))

        let startCount = table.cells.count

        app.buttons["🔄"].tap()

        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "count > %d", startCount),
            object: table.cells
        )
        _ = XCTWaiter().wait(for: [expectation], timeout: timeout)
    }

    func testInfiniteScroll_loadsMoreUsers() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: timeout))

        let initialCount = table.cells.count

        app.buttons["↓"].tap()

        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "count > %d", initialCount),
            object: table.cells
        )
        _ = XCTWaiter().wait(for: [expectation], timeout: timeout)
    }

    func testInitError_showsAlert() {
        let app = Helpers.launchApp(stubMode: "init-error")

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: timeout))

        app.buttons["🔄"].tap()
        
        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.waitForExistence(timeout: timeout))
        XCTAssertTrue(alert.buttons["OK"].exists)
    }


    func testLoadMoreError_showsFooterMessage() {
        let app = Helpers.launchApp(stubMode: "loadmore-error")

        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: timeout))

        app.buttons["↓"].tap()

        let footerText = "To see more, please reconnect to the internet."
        let footerLabel = app.staticTexts[footerText]
        XCTAssertTrue(footerLabel.waitForExistence(timeout: timeout))
    }
    
    func testTapOnUserCell_navigatesToDetail() {
        let app = Helpers.launchApp()
        let table = app.tables.firstMatch
        XCTAssertTrue(table.waitForExistence(timeout: timeout))
        
        // On récupère la première cellule de la table
        let firstCell = table.cells.firstMatch
        XCTAssertTrue(firstCell.exists, "Aucune cellule trouvée dans la table")

        // On simule un tap sur la première cellule
        firstCell.tap()

        // On attend un élément visible sur la page de détail
        // À adapter selon ton UI (titre, label, bouton, etc.)
        let detailTitle = app.staticTexts["User Detail"]
        XCTAssertTrue(detailTitle.waitForExistence(timeout: timeout), "La page de détail ne s'est pas affichée")
    }

}
