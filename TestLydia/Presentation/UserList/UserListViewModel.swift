//
//  UserListViewModel.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import FactoryKit
import UIKit
import Combine

class UserListViewModel {
    struct K {
        static let batchSize = 10
    }
    
    var usersCount: Int {
        return users.count
    }
    var isLoading = false
    let dataNeedsReload = PassthroughSubject<Void, Never>()
    let initErrorPublisher = PassthroughSubject<String, Never>()
    let loadMoreErrorPublisher = PassthroughSubject<String, Never>()
    
    @Injected(\.fetchUsersUseCase) private var fetchUsersUseCase: FetchUsersUseCase
    @Injected(\.fetchNextUsersUseCase) private var fetchNextUsersUseCase: FetchNextUsersUseCase
    
    private var users: [UserEntity] = []
    private let coordinator: UserListCoordinator
    
    init(coordinator: UserListCoordinator) {
        self.coordinator = coordinator
    }
    
    func initialLoad() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            users = try await fetchUsersUseCase.execute(batchSize: K.batchSize)
            isLoading = false
            dataNeedsReload.send()
        } catch {
            initErrorPublisher.send("Failed to load users: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func refresh() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            users = try await fetchNextUsersUseCase.execute(batchSize: K.batchSize)
            isLoading = false
            dataNeedsReload.send()
        } catch {
            initErrorPublisher.send("Failed to load users: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func loadMore() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            var newUsers: [UserEntity]
            newUsers = try await fetchNextUsersUseCase.execute(batchSize: K.batchSize)
            
            self.users.append(contentsOf: newUsers)
            isLoading = false
            dataNeedsReload.send()
        } catch {
            loadMoreErrorPublisher.send("Failed to load users: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    func showUserDetail(for index: Int) {
        let user = users[index]
        coordinator.showUserDetail(user: user)
    }
    
    func getCellModel(for index: Int) -> UserCellEntity {
        return users[index].asCellEntity()
    }
}
