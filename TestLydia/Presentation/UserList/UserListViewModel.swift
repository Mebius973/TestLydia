//
//  UserListViewModel.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import FactoryKit
import UIKit

class UserListViewModel {
    struct K {
        static let batchSize = 10
    }
    
    var usersCount: Int {
        return users.count
    }
    
    @Injected(\.fetchUsersUseCase) private var fetchUsersUseCase: FetchUsersUseCase
    @Injected(\.fetchNextUsersUseCase) private var fetchNextUsersUseCase: FetchNextUsersUseCase
    
    private var users: [UserEntity] = []
    private var paginationInfo: PaginationInfoEntitiy?
    private var currentPage: Int = 1
    private var isLoading = false
    private let coordinator: UserListCoordinator
    
    init(coordinator: UserListCoordinator) {
        self.coordinator = coordinator
    }
    
    func initialLoad() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            (users, paginationInfo) = try await fetchUsersUseCase.execute(batchSize: K.batchSize)
            isLoading = false
        } catch {
            print("Error fetching users: \(error)")
            isLoading = false
        }
    }
    
    func loadMore() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            var newUsers: [UserEntity]
            (newUsers, paginationInfo) = try await fetchNextUsersUseCase.execute(batchSize: K.batchSize, currentPage: currentPage, paginationInfo: paginationInfo)
            
            self.users.append(contentsOf: newUsers)
            isLoading = false
        } catch {
            print("Error fetching users: \(error)")
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
