//
//  Coordinator.swift
//  PokéDex
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


/// `Coordinator` is a protocol that defines the basic structure for coordinators in the application.
/// Coordinators are responsible for managing navigation flow and child coordinators.
protocol Coordinator: AnyObject {
    /// An array to keep track of child coordinators.
    var childCoordinators: [Coordinator] { get set }
    
    /// The navigation controller used for navigation.
    var navigationController: UINavigationController { get set }
    
    /// Starts the coordinator.
    func start()
}


protocol ChildCoordinatorDelegate: AnyObject {
    func childDidFinish(_ coordinator: Coordinator)
}
