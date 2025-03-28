//
//  SplashCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit


class SplashCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let dataManager = PokemonDataManager.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if dataManager.hasStoredObjects() {
            let pokemonDetailModels = dataManager.getAllPokemonDetails()
            let pokeDexListCoordinator = PokeDexCoordinator(navigationController: navigationController, pokeDexInventory: pokemonDetailModels)
            pokeDexListCoordinator.start()
        } else {
            Task {
                let service = PokemonService(client: NetworkClient())
                do {
                    try await service.fetchPokemons()
                    let pokedexInventory = dataManager.getAllPokemonDetails()
                    let pokeDexListCoordinator = PokeDexCoordinator(navigationController: navigationController, pokeDexInventory: pokedexInventory)
                    pokeDexListCoordinator.start()
                } catch {
                    // TODO: return error to coordinator to present error
                    print(error.localizedDescription)
                }
            }
        }
    }
}
