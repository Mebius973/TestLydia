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
        let detailViewModel = UserDetailViewModel(user: user)
        let detailViewController = UserDetailViewController(viewModel: detailViewModel)
        push(detailViewController)
    }
    
    func back() {
        pop()
    }
}
