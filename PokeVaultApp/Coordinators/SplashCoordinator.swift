//
//  SplashCoordinator.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit


// MARK: - SplashDelegate

/**
 A protocol used by the splash view controller to notify its coordinator when the splash process is complete.
 
 Conforming types (typically a coordinator) implement this method to proceed with navigation after the splash screen finishes loading.
 */
protocol SplashCoordinatorDelegate: AnyObject {
    func splashCoordinatorDidFinish(_ coordinator: SplashCoordinator)
}

// MARK: - SplashCoordinator

/// `SplashCoordinator` is responsible for managing the navigation flow during the splash screen.
/// It determines whether to navigate to the PokeDex list screen immediately based on stored Pokémon details,
/// or to fetch data from the network first and then proceed.
///
/// The coordinator holds any child coordinators while managing its specific flow and delegates navigation decisions
/// using the splash delegate method.
class SplashCoordinator: Coordinator {
    var children: [Coordinator] = .init()
    var navigationController: UINavigationController
    weak var childDelegate: ChildCoordinatorDelegate?
    private let dataManager: PokemonDataManager
    private let pokemonService: PokemonService
    
    var splashVC: SplashVC?
    
    init(window: UIWindow, navigationController: UINavigationController, dataManager: PokemonDataManager, pokemonService: PokemonService) {
        self.navigationController = navigationController
        self.dataManager = dataManager
        self.pokemonService = pokemonService
    }
    
    func start() {
        let splashVC = SplashVC()
        self.splashVC = splashVC
        
        navigationController.present(splashVC, animated: false)
        
        Task {
            await fetchAndSaveInitialData()
        }
    }
    
    private func fetchAndSaveInitialData() async {
        do {
            try await pokemonService.fetchAndSaveAllPokemonsDetails()
            dismissSplashVC()
            childDelegate?.didFinish(self)
        } catch {
            print("Error fetching initial data: \(error)")
            dismissSplashVC()
            childDelegate?.didFinish(self)
        }
    }
    
    private func dismissSplashVC() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.navigationController.dismiss(animated: false)
            self.splashVC = nil
        }
    }
    
    func finish() {
        dismissSplashVC()
    }
}
