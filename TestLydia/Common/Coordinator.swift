//
//  Coordinator.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func pop() {
        navigationController.popViewController(animated: false)
    }
}
