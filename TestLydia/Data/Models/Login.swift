//
//  Login.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//


struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}