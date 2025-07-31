//
//  SceneDelegate.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit
import SwiftData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: ApplicationCoordinator?
    var sharedModelContainer: ModelContainer!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        do {
            sharedModelContainer = try createSharedModelContainer()
        } catch {
            fatalError("Failed to set up shared ModelContainer: \(error)")
        }
        
        appCoordinator = ApplicationCoordinator(window: UIWindow(windowScene: windowScene), sharedCoordinator: sharedModelContainer)
        appCoordinator?.start()
    }
    
    func createSharedModelContainer(isInMemoryOnly: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            PokemonDetailModel.self
        ])
        
        let configuration = ModelConfiguration(
            "PokemonVaultDataStore",
            schema: schema,
            isStoredInMemoryOnly: isInMemoryOnly
        )
        
        return try ModelContainer(
            for: schema,
            migrationPlan: MigrationPlan.self,
            configurations: configuration
        )
    }
}

