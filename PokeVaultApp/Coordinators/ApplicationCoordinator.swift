//
//  ApplicationCoordinator.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit


/// `ApplicationCoordinator` is responsible for managing the application's main window and navigation flow.
/// It initializes the root view controller and starts the initial coordinator.
class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    /// Initializes a new instance of `ApplicationCoordinator` with the given window.
    /// - Parameter window: The main window of the application.
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
    }
    
    /// Starts the application by initializing and starting the `SplashCoordinator`.
    func start() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
        window.makeKeyAndVisible()
    }
}
