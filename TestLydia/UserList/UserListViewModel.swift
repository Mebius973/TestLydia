//
//  UserListViewModel.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import FactoryKit

class UserListViewModel {
    var users: [User] {
        randomUserResult?.users ?? []
    }
    var usersCount: Int {
        return randomUserResult?.users.count ?? 0
    }
    
    @Injected(\.userService) private var service: UserService
    
    private var randomUserResult: RandomUserResults?
    private var isLoading = false

    func loadMore() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let randomUserResult = try await service.fetchUsers()
            self.randomUserResult = randomUserResult
            isLoading = false
        } catch {
            print("Error fetching users: \(error)")
            isLoading = false
        }
    }
}
