//
//  AppDelegate.swift
//  TestLydia
//
//  Created by David Geoffroy on 25/06/2025.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: Coordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        coordinator = UserListCoordinator(navigationController: UINavigationController())
        coordinator?.start()
        window?.rootViewController = coordinator?.navigationController
        
        window?.makeKeyAndVisible()
        return true
    }
}

