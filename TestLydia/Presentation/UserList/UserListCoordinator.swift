//
//  UserListCoordinator.swift
//  TestLydia
//
//  Created by Mebius on 25/06/2025.
//
import UIKit

class UserListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var presentedViewController: UIViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = UserListViewModel(coordinator: self)
        presentedViewController = UserListViewController(viewModel: viewModel)
        guard let presentedViewController = presentedViewController else { return }
        push(presentedViewController)
    }

    func showUserDetail(user: UserEntity) {
        let coordinator = UserDetailCoordinator(user: user, navigationController: navigationController)
        coordinator.start()
    }
}



