//
//  UserEntity.swift
//  TestLydia
//
//  Created by David Geoffroy on 26/06/2025.
//

import Foundation

struct UserEntity: Codable {
    // Base
    let gender: String
    let email: String
    let phone: String
    let cell: String
    let nat: String

    // Name
    let title: String
    let firstName: String
    let lastName: String

    // Location
    let streetNumber: Int
    let streetName: String
    let city: String
    let state: String
    let country: String
    let postcode: String
    let coordinatesLatitude: String
    let coordinatesLongitude: String
    let timezoneOffset: String
    let timezoneDescription: String

    // Login
    let loginUUID: String
    let loginUsername: String
    let loginPassword: String
    let loginSalt: String
    let loginMD5: String
    let loginSHA1: String
    let loginSHA256: String

    // DOB
    let dobDate: String
    let dobAge: Int

    // Registered (même structure que DOB)
    let registeredDate: String
    let registeredAge: Int

    // ID
    let idName: String
    let idValue: String?

    // Picture
    let pictureLarge: String
    let pictureMedium: String
    let pictureThumbnail: String
    
    let rawProfilePicture: Data?
}

extension UserEntity {
    func asCellEntity() -> UserCellEntity {
        let name = "\(title) \(firstName) \(lastName)"
        return UserCellEntity(name: name, rawImage: rawProfilePicture)
    }
}
