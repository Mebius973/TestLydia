//
//  UserEntity+mock.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//
@testable import TestLydia

extension UserEntity {
    static func mock(index: Int) -> UserEntity {
        return UserEntity(
            gender: "male",
            email: "test\(index)@example.com",
            phone: "123456789",
            cell: "987654321",
            nat: "US",
            title: "Mr",
            firstName: "firstName\(index)",
            lastName: "lastName\(index)",
            streetNumber: 123,
            streetName: "Main St",
            city: "Test City",
            state: "Test State",
            country: "Test Country",
            postcode: "12345",
            coordinatesLatitude: "0.0",
            coordinatesLongitude: "0.0",
            timezoneOffset: "+00:00",
            timezoneDescription: "UTC",
            loginUUID: "uuid",
            loginUsername: "username\(index)",
            loginPassword: "password\(index)",
            loginSalt: "salt",
            loginMD5: "md5",
            loginSHA1: "sha1",
            loginSHA256: "sha256",
            dobDate: "1990-01-01",
            dobAge: 30,
            registeredDate: "2020-01-01",
            registeredAge: 5,
            idName: "SSN",
            idValue: "123-45-6789",
            pictureLarge: "https://example.com/large.jpg",
            pictureMedium: "https://example.com/medium.jpg",
            pictureThumbnail: "https://example.com/thumb.jpg",
            rawProfilePicture: nil
        )
    }
    
    static func mocks(count: Int = 3) -> [UserEntity] {
        return (0..<count).map { index in
            mock(index: index)
        }
    }
}
