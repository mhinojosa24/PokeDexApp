//
//  PokeDexCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


/// `PokeDexCoordinator` is responsible for managing the navigation flow for the PokeDex feature.
/// It initializes the view model and view controller for the PokeDex list and handles navigation.
class PokeDexCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var pokeDexInventory: [PokemonDetailModel]
    
    /// Initializes a new instance of `PokeDexCoordinator` with the given navigation controller and PokeDex inventory.
    /// - Parameters:
    ///   - navigationController: The navigation controller used for navigation.
    ///   - pokeDexInventory: The inventory of Pokemon details.
    init(navigationController: UINavigationController, pokeDexInventory: [PokemonDetailModel]) {
        self.navigationController = navigationController
        self.pokeDexInventory = pokeDexInventory
    }
    
    /// Starts the PokeDex coordinator by initializing and pushing the PokeDex list view controller.
    func start() {
        DispatchQueue.main.async {
            let viewModel = PokeDexListVM(inventory: self.pokeDexInventory)
            let pokeDexListVC = PokeDexListVC(viewModel: viewModel)
            self.navigationController.viewControllers = self.navigationController.viewControllers.filter { !($0 is SplashVC) }
            self.navigationController.setViewControllers([pokeDexListVC], animated: true)
        }
    }
}
