//
//  Info+mock.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//

@testable import TestLydia

extension Info {
    static func mock(_ resultCount: Int = 0) -> Info {
        Info(seed: "seed", results: resultCount, page: 1, version: "seed")
    }
}
