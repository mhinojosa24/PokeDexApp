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
protocol PokeDexDelegate: AnyObject {
    func didSelectPokemon(_ pokemonDetails: PokemonDetailModel)
}

// MARK: - PokeDexCoordinator

/// `PokeDexCoordinator` is responsible for managing the navigation flow for the PokeDex feature.
/// It initializes the view model and view controller for the PokeDex list and handles navigation.
class PokeDexCoordinator: Coordinator {
/// An array that holds child coordinators currently in use by the PokeDex flow.
    var childCoordinators: [Coordinator] = []
    
    /// The navigation controller used for presenting the PokeDex screens.
    var navigationController: UINavigationController
    
    /// A delegate conforming to `ChildCoordinatorDelegate` which is notified when this coordinator finishes its flow.
    weak var delegate: ChildCoordinatorDelegate?
    
    /// Initializes a new instance of `PokeDexCoordinator` with the given navigation controller.
    /// - Parameter navigationController: The navigation controller used for navigation.
    /// - Note: You can also pass additional configuration such as a PokeDex inventory if needed.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /// Starts the PokeDex flow by initializing the PokeDex list view controller and setting it
    /// as the root view controller of the navigation stack (after filtering out the Splash screen, if any).
    func start() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let viewModel = PokeDexListVM()
            let pokeDexListVC = PokeDexListVC(viewModel: viewModel)
            pokeDexListVC.delegate = self
            self.navigationController.viewControllers = self.navigationController.viewControllers.filter { !($0 is SplashVC) }
            self.navigationController.setViewControllers([pokeDexListVC], animated: true)
        }
    }
    
    /// Initiates the detail flow by creating a new PokeDexDetailCoordinator for the selected Pokemon,
    /// setting its delegate to self, storing it in the childCoordinators array, and starting it.
    /// - Parameter pokemonDetails: The details for the selected Pokemon.
    func showDetails(with pokemonDetails: PokemonDetailModel) {
        let pokeDexDetailCoordinator = PokeDexDetailCoordinator(pokemonDetails: pokemonDetails, navigationController: navigationController)
        pokeDexDetailCoordinator.delegate = self
        childCoordinators.append(pokeDexDetailCoordinator)
        pokeDexDetailCoordinator.start()
    }
}

// MARK: - PokeDexDelegate

extension PokeDexCoordinator: PokeDexDelegate {
    /// Responds to the selection of a Pokemon by triggering the detail flow.
    /// - Parameter pokemonDetails: The selected Pokemon's details.
    func didSelectPokemon(_ pokemonDetails: PokemonDetailModel) {
        showDetails(with: pokemonDetails)
    }
}

// MARK: - ChildCoordinatorDelegate

extension PokeDexCoordinator: ChildCoordinatorDelegate {
    /// Notifies the parent coordinator that a child coordinator has finished its flow,
    /// and removes it from the `childCoordinators` array.
    /// - Parameter coordinator: The child coordinator that has completed its work.
    func childDidFinish(_ coordinator: any Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
