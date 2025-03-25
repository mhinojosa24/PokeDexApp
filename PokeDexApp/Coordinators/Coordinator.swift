//
//  Coordinator.swift
//  PokéDex
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

// MARK: Application Coordinator
class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
    }
    
    func start() {
    }
}
