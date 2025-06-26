//
//  DIManager.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//

import FactoryKit

extension Container {
    var userRepository: Factory<UserRepository> {
        Factory(self) { UserRepositoryImpl() }
    }
    
    var fetchUsersUseCase: Factory<FetchUsersUseCase> {
        Factory(self) { FetchUsersUseCaseImpl() }
    }
    
    var fetchNextUsersUseCase: Factory<FetchNextUsersUseCase> {
        Factory(self) { FetchNextUsersUseCaseImpl() }
    }
}
