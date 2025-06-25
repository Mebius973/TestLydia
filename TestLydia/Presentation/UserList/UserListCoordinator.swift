//
//  UserListCoordinator.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import UIKit

class UserListCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = UserListViewModel(coordinator: self)
        let viewController = UserListViewController(viewModel: viewModel)
        push(viewController)
    }

    func showUserDetail(user: UserEntity) {
        let coordinator = UserDetailCoordinator(user: user, navigationController: navigationController)
        coordinator.start()
    }
}
