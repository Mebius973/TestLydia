//
//  RandomUserResults.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//

import Foundation

struct RandomUserResults: Codable {
    let users: [User]
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case users = "results"
        case info
    }
}
