//
//  User.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

struct User: Codable {
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob, registered: Dob
    let phone, cell: String
    let id: ID
    let picture: Picture
    let nat: String
}
