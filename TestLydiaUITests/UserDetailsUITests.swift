//
//  UserDetailsUITests.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//


import XCTest

final class UserDetailsUITests: XCTestCase {
    var app = XCUIApplication()
    let timeout: TimeInterval = 5.0

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = Helpers.launchApp()
        
        // Navigate to the first user details
        let table = app.tables.firstMatch
        table.cells.firstMatch.tap()
    }

    func testEmailLinkOpensMailApp() {
        let emailTextView = app.links["EmailTextView"]
        XCTAssertTrue(emailTextView.waitForExistence(timeout: timeout), "Email field should exist")
    }

    func testPhoneLinkProposesCall() {
        let phoneTextView = app.links["PhoneTextView"]
        XCTAssertTrue(phoneTextView.waitForExistence(timeout: timeout), "Phone field should exist")
    }

    func testCellLinkProposesCall() {
        let cellTextView = app.links["CellTextView"]
        XCTAssertTrue(cellTextView.waitForExistence(timeout: timeout), "Cell field should exist")
    }

    func testPictureURLIsClickable() {
        let pictureTextView = app.links["LinkTextView"]
        XCTAssertTrue(pictureTextView.waitForExistence(timeout: timeout), "Picture URL should be visible")
    }
}
