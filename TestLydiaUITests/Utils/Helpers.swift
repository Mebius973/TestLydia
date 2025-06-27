//
//  Helpers.swift
//  TestLydia
//
//  Created by Mebius on 27/06/2025.
//

import XCTest

class Helpers {
    static func launchApp(stubMode: String? = nil, testMode: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        var url = "http://localhost:1080/api"
        if let mode = stubMode {
            url += "?mode=\(mode)"
        }
        
        app.launchEnvironment = [
            "API_BASE_URL": url,
            "UI_TEST_MODE": testMode ? "1" : "0"
        ]
        app.launch()
        return app
    }

}
