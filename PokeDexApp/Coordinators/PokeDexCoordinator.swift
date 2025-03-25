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
        let pokeDexListVC = PokeDexListVC(viewModel: PokeDexListVM())
        navigationController.pushViewController(pokeDexListVC, animated: true)
    }
}
