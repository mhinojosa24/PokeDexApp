//
//  PokeDexListVM.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import Combine

/// A protocol that defines the interface for a Pokémon view model responsible for
/// fetching, filtering, and providing Pokémon list data for display.
protocol PokemonVM {
    var inventoryPublisher: Published<[PokemonCell.UIModel]>.Publisher { get }
    
    /// Asynchronously populates the full Pokémon list and triggers the publisher.
    func populate() async throws
    
    /// Retrieves detailed Pokémon data by its Pokédex ID.
    func getPokemonDetails(by id: Int) async throws -> PokemonDetailModel?
}

/// A view model responsible for managing the Pokémon list data,
/// including retrieval, transformation into UI models, and filtering.
class PokeDexListVM: PokemonVM, ObservableObject {
    var inventoryPublisher: Published<[PokemonCell.UIModel]>.Publisher { $pokemonInventory }
    private let dataManager: PokemonDataManager
    
    /// Stores the list of Pokémon UI models and triggers the publisher when changed.
    @Published private var pokemonInventory: [PokemonCell.UIModel] = .init()
    private var filteredInventory: [PokemonCell.UIModel] = .init()
    
    init(dataManager: PokemonDataManager) {
        self.dataManager = dataManager
    }
    
    /// Fetches all stored Pokémon details, maps them into UI models,
    /// and publishes the list to update the UI.
    func populate() async throws {
        do {
            let inventory: [PokemonDetailModel] = try await dataManager.fetchAllPokemonDetails()
            pokemonInventory = inventory.compactMap {
                PokemonCell.UIModel(thumbnail: $0.sprite.artwork,
                                    name: $0.name,
                                    pokedexNumber: $0.id,
                                    colorType: .init($0.themeColor)
                )
            }
        } catch {
            throw error
        }
    }
    
    /// Retrieves a stored Pokémon detail by its ID from the data manager.
    ///
    /// - Parameter id: The Pokédex number of the Pokémon.
    /// - Returns: A `PokemonDetailModel` if found, otherwise nil.
    func getPokemonDetails(by id: Int) async throws -> PokemonDetailModel? {
        do {
            return try await dataManager.fetchPokemonDetail(byID: id)
        } catch {
            throw error
        }
    }
}
