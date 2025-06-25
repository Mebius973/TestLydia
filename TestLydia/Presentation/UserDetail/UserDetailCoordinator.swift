//
//  UserDetailCoordinator.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import UIKit

class UserDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var user: UserEntity
    
    init(user: UserEntity, navigationController: UINavigationController) {
        self.user = user
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = UserDetailViewModel(user: user)
        let viewController = UserDetailViewController(viewModel: viewModel)
        push(viewController)
    }
    
    func back() {
        pop()
    }
}
