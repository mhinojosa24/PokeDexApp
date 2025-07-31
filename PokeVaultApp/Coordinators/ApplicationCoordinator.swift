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
    var children: [Coordinator] = .init()
    var navigationController: UINavigationController
    private let window: UIWindow
    private let sharedModelContainer: ModelContainer
    private let dataActor: DataActorProtocol
    private let dataManager: PokemonDataManager
    
    /// Initializes a new instance of `ApplicationCoordinator` with the given window.
    /// - Parameter window: The main window of the application.
    init(window: UIWindow, sharedCoordinator: ModelContainer) {
        self.window = window
        self.sharedModelContainer = sharedCoordinator
        self.dataActor = DataStoreActor(modelContainer: sharedModelContainer)
        self.dataManager = PokemonDataManager(dataStoreActor: dataActor)
        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
    }
    
    /// Starts the application by initializing and starting the `SplashCoordinator`.
    func start() {
        Task {
            await decideInitialFlow()
        }
    }
    
    private func decideInitialFlow() async {
        do {
            let isStorePopulated = try await !dataManager.isPokemonDataStoreEmpty()
            if isStorePopulated {
                // Data exists. But is it up-to-date?
                let storedVersion = UserDefaults.standard.integer(forKey: "storedDataVersion")
                if storedVersion < LATEST_DATA_VERSION {
                    print("Data is stale. Triggering background refresh.")
                    showSplashFlow()
                } else {
                    print("Data is current. Showing main flow.")
                    showMainFlow()
                }
            } else {
                print("No local data found. Showing splash flow.")
                showSplashFlow()
            }
        } catch {
            print("Error checking local data: \(error)")
            // NOTE: show main flow with an empty state
            showMainFlow()
        }
    }
    
    private func showMainFlow() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let mainCoordinator = PokeDexCoordinator(navigationController: navigationController, dataManager: dataManager)
            children.append(mainCoordinator)
            mainCoordinator.start()

            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    
    private func showSplashFlow() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UserDefaults.standard.set(LATEST_DATA_VERSION, forKey: "storedDataVersion")
            let pokemonService = PokemonService(client: NetworkClient(), dataManager: dataManager)
            let splashCoordinator = SplashCoordinator(window: window, navigationController: navigationController, dataManager: dataManager, pokemonService: pokemonService)
            children.append(splashCoordinator)
            splashCoordinator.childDelegate = self
            splashCoordinator.start()
            
            window.rootViewController = splashCoordinator.splashVC
            window.makeKeyAndVisible()
        }
    }
    
    func finish() {
    
    }
}

extension ApplicationCoordinator: ChildCoordinatorDelegate {
    func didFinish(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
        coordinator.finish()
        showMainFlow()
    }
    
    
}
