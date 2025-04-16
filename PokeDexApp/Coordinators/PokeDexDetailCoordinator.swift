//
//  PokeDexDetailCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/15/25.
//

import UIKit

// MARK: - PokeDexDetailDelegate

/**
 A delegate protocol for PokeDexDetail events.
 
 Conforming types (typically a coordinator or view controller) implement this protocol
 to handle user actions from the Pokemon Detail screen.
 */
protocol PokeDexDetailDelegate: AnyObject {
    /// Called when the user taps the back button on the Pokemon Detail screen.
    func didTapBackButton()
}

// MARK: - PokeDexDetailCoordinator

/**
 The PokeDexDetailCoordinator is responsible for managing the navigation flow
 for the Pokemon Detail screen. It initializes the view model and view controller
 for the detail flow and pushes the detail view controller onto the navigation stack.
 
 It also communicates with its parent coordinator via the ChildCoordinatorDelegate
 to signal when its flow has ended.
 */
class PokeDexDetailCoordinator: Coordinator {
    /// An array that holds any child coordinators. This is used for managing subordinate flows.
    var childCoordinators: [Coordinator] = []
    
    /// The navigation controller used for managing the navigation stack.
    var navigationController: UINavigationController
    
    /// The Pokemon detail model that contains the details to be displayed.
    var pokemonDetails: PokemonDetailModel
    
    /// A delegate that conforms to ChildCoordinatorDelegate. This is notified when this coordinator finishes its flow.
    weak var delegate: ChildCoordinatorDelegate?
    
    /**
     Initializes a new instance of PokeDexDetailCoordinator.
     
     - Parameters:
       - pokemonDetails: The model containing details for the selected Pokemon.
       - navigationController: The navigation controller used for navigation.
     */
    init(pokemonDetails: PokemonDetailModel, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.pokemonDetails = pokemonDetails
    }
    
    /**
     Starts the PokeDex Detail flow.
     
     This method creates the detail view model and view controller, sets up the delegate,
     and pushes the detail view controller onto the navigation stack.
     */
    func start() {
        let viewModel = PokeDexDetailVM(pokemonDetails)
        let pokeDexDetailVC = PokeDexDetailVC()
        pokeDexDetailVC.delegate = self
        navigationController.pushViewController(pokeDexDetailVC, animated: true)
    }
}

// MARK: - PokeDexDetailDelegate
extension PokeDexDetailCoordinator: PokeDexDetailDelegate {
    /**
     Handles the back button tap event from the Pokemon Detail screen.
     
     This method pops the current detail view controller off the navigation stack and
     notifies the parent coordinator that the PokeDex detail flow has finished.
     */
    func didTapBackButton() {
        // Depending on your desired behavior you can pop to root or just pop one view controller.
        // Here, we simply pop the current view controller:
        navigationController.popViewController(animated: true)
        
        // Notify the parent coordinator (which conforms to ChildCoordinatorDelegate)
        delegate?.childDidFinish(self)
    }
}
