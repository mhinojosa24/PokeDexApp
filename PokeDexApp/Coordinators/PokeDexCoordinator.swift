//
//  PokeDexCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


class PokeDexCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var pokeDexInventory: [PokemonDetailModel]
    
    init(navigationController: UINavigationController, pokeDexInventory: [PokemonDetailModel]) {
        self.navigationController = navigationController
        self.pokeDexInventory = pokeDexInventory
    }
    
    func start() {
        let service = PokemonService(client: NetworkClient())
        let viewModel = PokeDexListVM(inventory: pokeDexInventory)
        let pokeDexListVC = PokeDexListVC(viewModel: viewModel)
        navigationController.pushViewController(pokeDexListVC, animated: true)
    }
}
