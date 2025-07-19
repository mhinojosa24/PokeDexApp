//
//  PokeDexCoordinator.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit

// MARK: - PokeDexDelegate

/**
 A protocol that defines the delegate methods for handling Pokemon selection events in the PokeDex flow.
 
 Conforming types (typically view controllers or coordinators) will implement this protocol to respond when a user selects a Pokemon in the PokeDex list.
 
 - Note: This protocol is constrained to class types by conforming to `AnyObject` so that delegate references can be marked as weak.
 */
@MainActor
protocol PokeDexDelegate: AnyObject {
    func didSelectPokemon(_ pokemonDetails: PokemonDetailModel)
}

// MARK: - PokeDexCoordinator

/// `PokeDexCoordinator` is responsible for managing the navigation flow for the PokeDex feature.
/// It initializes the view model and view controller for the PokeDex list and handles navigation.
class PokeDexCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let dataManager: PokemonDataManager
    
    init(navigationController: UINavigationController, dataManager: PokemonDataManager) {
        self.navigationController = navigationController
        self.dataManager = dataManager
    }
    
    func start() {
        let viewModel = PokeDexListVM(dataManager: dataManager)
        let pokeDexListVC = PokeDexListVC(viewModel: viewModel)
        pokeDexListVC.delegate = self
        navigationController.pushViewController(pokeDexListVC, animated: true)
    }
    
    private func showDetails(with pokemonDetails: PokemonDetailModel) {
        let pokeDexDetailCoordinator = PokeDexDetailCoordinator(pokemonDetails: pokemonDetails, navigationController: navigationController)
        pokeDexDetailCoordinator.childDelegate = self
        children.append(pokeDexDetailCoordinator)
        pokeDexDetailCoordinator.start()
    }
    
    func finish() {
    
    }
}

// MARK: - PokeDexDelegate

extension PokeDexCoordinator: PokeDexDelegate {
    func didSelectPokemon(_ pokemonDetails: PokemonDetailModel) {
        showDetails(with: pokemonDetails)
    }
}

// MARK: - ChildCoordinatorDelegate

extension PokeDexCoordinator: ChildCoordinatorDelegate {
    func didFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
        coordinator.finish()
    }
}
