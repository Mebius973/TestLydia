//
//  User+init.swift
//  TestLydia
//
//  Created by David Geoffroy on 30/06/2025.
//

@testable import TestLydia

extension User {
    init(_ from: UserEntity) {
        self.init(gender: from.gender,
             name: .init(title: from.title,
                         first: from.firstName,
                         last: from.lastName),
             location: .init(street: .init(number: from.streetNumber,
                                                name: from.streetName),
                             city: from.city,
                             state: from.state,
                             country: from.country,
                             postcode: from.postcode,
                             coordinates: .init(latitude: from.coordinatesLatitude,
                                                    longitude: from.coordinatesLongitude),
                             timezone: .init(offset: from.timezoneOffset,
                                                    description: from.timezoneDescription)),
             email: from.email,
             login: .init(uuid: from.loginUUID,
                          username: from.loginUsername,
                          password: from.loginPassword,
                          salt: from.loginSalt,
                          md5: from.loginMD5,
                          sha1: from.loginSHA1,
                          sha256: from.loginSHA256),
             dob: .init(date: from.dobDate, age: from.dobAge),
             registered: .init(date: from.registeredDate, age: from.registeredAge),
             phone: from.phone,
             cell: from.cell,
             id: .init(name: from.idName, value: from.idValue),
             picture: .init(large: from.pictureLarge, medium: from.pictureMedium, thumbnail: from.pictureThumbnail),
             nat: from.nat)
    }
}
