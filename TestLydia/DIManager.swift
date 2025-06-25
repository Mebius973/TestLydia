//
//  DIManager.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//

import FactoryKit
import Foundation

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
    
    var urlSession: Factory<URLSessionProtocol> {
        Factory(self) { URLSession.shared }
    }
    
    var cacheManager: Factory<CacheManagerProtocol> {
        Factory(self) { CacheManager() }
    }
}
