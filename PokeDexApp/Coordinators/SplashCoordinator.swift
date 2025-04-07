//
//  SplashCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit

protocol SplashDelegate {
    func didLoadSplash()
}

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
        let splashVC = SplashVC()
        splashVC.delegate = self
        navigationController.pushViewController(splashVC, animated: true)
    }
    
    private func showPokeDexList() {
        let pokeDexCoordinator = PokeDexCoordinator(navigationController: navigationController)
        pokeDexCoordinator.start()
    }
}

extension SplashCoordinator: SplashDelegate {
    func didLoadSplash() {
        dataManager.clearPokeDexInventory() // remove after testing
        if dataManager.hasStoredItems() {
            showPokeDexList()
        } else {
            Task {
                do {
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForRequest = 15
                    configuration.timeoutIntervalForResource = 30
                    let session = URLSession(configuration: configuration)
                    let client = NetworkClient(session: session)
                    let service = PokemonService(client: client)
                    try await service.fetchPokemons()
                    showPokeDexList()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
