//
//  ApplicationCoordinator.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit
import SwiftData

/// `ApplicationCoordinator` is responsible for managing the application's main window and navigation flow.
/// It initializes the root view controller and starts the initial coordinator.
class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    private let sharedModelContainer: ModelContainer
    private let dataActor: DataActorProtocol
    private let dataManager: PokemonDataManager
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    /// Initializes a new instance of `ApplicationCoordinator` with the given window.
    /// - Parameter window: The main window of the application.
    init(window: UIWindow) {
        self.window = window
        
        let schema = Schema([PokemonDetailModel.self])
        let config = ModelConfiguration("PokemonVaultDataStore")
        do {
            self.sharedModelContainer = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Unable to initialize CoreData stack: \(error)")
        }
        
        self.dataActor = DataStoreActor(modelContainer: sharedModelContainer)
        self.dataManager = PokemonDataManager(dataStoreActor: dataActor)
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
    }
    
    /// Starts the application by initializing and starting the `SplashCoordinator`.
    func start() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController, dataManager: dataManager)
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
        window.makeKeyAndVisible()
    }
}
