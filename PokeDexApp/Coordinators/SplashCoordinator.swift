//
//  SplashCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit

/// `SplashCoordinator` is responsible for managing the navigation flow during the splash screen.
/// It checks if there are stored Pokemon details and navigates accordingly.
class SplashCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let dataManager = PokemonDataManager.shared
    
    /// Initializes a new instance of `SplashCoordinator` with the given navigation controller.
    /// - Parameter navigationController: The navigation controller used for navigation.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Starts the splash coordinator by checking for stored Pokemon details and navigating accordingly.
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
