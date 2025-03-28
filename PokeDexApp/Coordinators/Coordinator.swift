//
//  Coordinator.swift
//  PokéDex
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


/// `Coordinator` is a protocol that defines the basic structure for coordinators in the application.
/// Coordinators are responsible for managing navigation flow and child coordinators.
protocol Coordinator {
    /// An array to keep track of child coordinators.
    var childCoordinators: [Coordinator] { get set }
    
    /// The navigation controller used for navigation.
    var navigationController: UINavigationController { get set }
    
    /// Starts the coordinator.
    func start()
}

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
        splashCoordinator.start()
        window.makeKeyAndVisible()
    }
}

