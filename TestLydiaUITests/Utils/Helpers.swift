//
//  Helpers.swift
//  TestLydia
//
//  Created by David Geoffroy on 27/06/2025.
//

import XCTest

class Helpers {
    static func launchApp(stubMode: String? = nil) -> XCUIApplication {
        let app = XCUIApplication()
        var url = "http://localhost:1080/api"
        if let mode = stubMode {
            url += "?mode=\(mode)"
        }
        
        app.launchEnvironment = [
            "API_BASE_URL": url,
            "UI_TEST_MODE": "1"
        ]
        app.launch()
        return app
    }

}
