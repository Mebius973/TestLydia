//
//  DIManager.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import FactoryKit

extension Container {
    var userService: Factory<UserService> {
        Factory(self) { UserService() }
    }
}
