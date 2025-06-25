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
    
    @Injected(\.userService) private var service: UserService
    
    var usersCount: Int {
        return users.count
    }
    
    private(set) var users: [User] = []
    private var info: Info?
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
            let randomUserResult = try await service.fetchUsers(batchSize: K.batchSize)
            users = randomUserResult.users
            info = randomUserResult.info
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
            var randomUserResult: RandomUserResults
            if let info = info, currentPage < info.page {
                randomUserResult = try await service.fetchNextUsers(seed: info.seed, page: currentPage + 1, batchSize: K.batchSize)
            } else {
                randomUserResult = try await service.fetchUsers(batchSize: K.batchSize)
            }
            users.append(contentsOf: randomUserResult.users)
            self.info = randomUserResult.info
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
    
    func getCellModel(for index: Int) async -> UserListViewCellModel {
        let user = users[index]
        var image: UIImage?
        if let url = URL(string: user.picture.thumbnail) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                image = UIImage(data: data)
            } catch {
                print("no Image")
            }
        }
        
        let name = "\(user.name.title) \(user.name.first) \(user.name.last)"
        return UserListViewCellModel(name: name, image: image)
        
    }
}
