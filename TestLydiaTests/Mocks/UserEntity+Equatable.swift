//
//  UserEntity+Equatable.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//
@testable import TestLydia

extension UserEntity: @retroactive Equatable {
    public static func == (lhs: UserEntity, rhs: UserEntity) -> Bool {
        return lhs.idName == rhs.idName && lhs.idValue == rhs.idValue
    }
}
