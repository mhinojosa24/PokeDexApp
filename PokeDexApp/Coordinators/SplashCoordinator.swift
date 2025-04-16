//
//  SplashCoordinator.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit


// MARK: - SplashDelegate

/**
 A protocol used by the splash view controller to notify its coordinator when the splash process is complete.
 
 Conforming types (typically a coordinator) implement this method to proceed with navigation after the splash screen finishes loading.
 */
protocol SplashDelegate: AnyObject {
    /// Called when the splash screen has finished its initialization (e.g. loading stored data or fetching from the network).
    func didLoadSplash()
}

// MARK: - SplashCoordinator

/// `SplashCoordinator` is responsible for managing the navigation flow during the splash screen.
/// It determines whether to navigate to the PokeDex list screen immediately based on stored Pokémon details,
/// or to fetch data from the network first and then proceed.
///
/// The coordinator holds any child coordinators while managing its specific flow and delegates navigation decisions
/// using the splash delegate method.
class SplashCoordinator: Coordinator {
    /// An array to store any child coordinators. This helps in retaining active coordinators and managing their lifecycles.
    var childCoordinators: [Coordinator] = []
    
    /// The navigation controller used to manage and push view controllers during the splash flow.
    var navigationController: UINavigationController
    
    /// A shared instance of PokemonDataManager used to check or manipulate stored Pokémon details.
    let dataManager = PokemonDataManager.shared
    
    /// A weak reference to an object that conforms to SplashDelegate.
    /// This delegate is notified when the splash loading is complete.
    weak var splashDelegate: SplashDelegate?
    
    /**
     Initializes a new instance of `SplashCoordinator` with the specified navigation controller.
     - Parameter navigationController: The navigation controller used for pushing and presenting view controllers in the splash flow.
     */
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    /**
     Starts the splash coordinator by creating and pushing the splash view controller onto the navigation stack.
     The splash view controller’s delegate is set to self so that this coordinator can be notified when the splash process completes.
     */
    func start() {
        let splashVC = SplashVC()
        splashVC.delegate = self
        navigationController.pushViewController(splashVC, animated: true)
    }
    
    /**
     Navigates to the PokeDex list screen.
     
     This method initializes a new `PokeDexCoordinator`, appends it to the list of child coordinators,
     and starts its flow. It’s used when the dataManager indicates that stored Pokémon details are available,
     or after a network fetch is completed.
     */
    private func showPokeDexList() {
        let pokeDexCoordinator = PokeDexCoordinator(navigationController: navigationController)
        childCoordinators.append(pokeDexCoordinator)
        pokeDexCoordinator.start()
    }
}

// MARK: - SplashCoordinator

extension SplashCoordinator: SplashDelegate {
    /**
     Called when the splash view controller has finished loading or processing its data.
     
     This method checks whether there are stored Pokémon details:
     - If stored items exist, it navigates immediately to the PokeDex list.
     - If not, it initiates a network request to fetch Pokémon data asynchronously.
       Once the network operation is complete, it navigates to the PokeDex list.
     
     - Note: The optional `dataManager.clearPokeDexInventory()` can be used during testing to simulate an empty store.
     */
    func didLoadSplash() {
        //dataManager.clearPokeDexInventory() // Remove after testing; this line can clear stored items for debugging purposes.
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
