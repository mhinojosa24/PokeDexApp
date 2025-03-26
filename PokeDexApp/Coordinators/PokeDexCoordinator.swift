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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let service = PokemonService(client: NetworkClient())
        let viewModel = PokeDexListVM(service: service)
        let pokeDexListVC = PokeDexListVC(viewModel: viewModel)
        navigationController.pushViewController(pokeDexListVC, animated: true)
    }
}
