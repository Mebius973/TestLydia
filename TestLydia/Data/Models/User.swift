//
//  User.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import Foundation

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

extension User {
    
    func asEntity(rawImage: Data?) -> UserEntity {
        UserEntity(
            gender: self.gender,
            email: self.email,
            phone: self.phone,
            cell: self.cell,
            nat: self.nat,
            
            title: self.name.title,
            firstName: self.name.first,
            lastName: self.name.last,
            
            streetNumber: self.location.street.number,
            streetName: self.location.street.name,
            city: self.location.city,
            state: self.location.state,
            country: self.location.country,
            postcode: self.location.postcode,
            coordinatesLatitude: self.location.coordinates.latitude,
            coordinatesLongitude: self.location.coordinates.longitude,
            timezoneOffset: self.location.timezone.offset,
            timezoneDescription: self.location.timezone.description,
            
            loginUUID: self.login.uuid,
            loginUsername: self.login.username,
            loginPassword: self.login.password,
            loginSalt: self.login.salt,
            loginMD5: self.login.md5,
            loginSHA1: self.login.sha1,
            loginSHA256: self.login.sha256,
            
            dobDate: self.dob.date,
            dobAge: self.dob.age,
            registeredDate: self.registered.date,
            registeredAge: self.registered.age,
            
            idName: self.id.name,
            idValue: self.id.value,
            
            pictureLarge: self.picture.large,
            pictureMedium: self.picture.medium,
            pictureThumbnail: self.picture.thumbnail,
            
            rawProfilePicture: rawImage
        )
    }
}
