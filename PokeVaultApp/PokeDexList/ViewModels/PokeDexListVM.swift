//
//  PokeDexListVM.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import Combine
import Foundation

/// A protocol that defines the interface for a Pokémon view model responsible for
/// fetching, filtering, and providing Pokémon list data for display.
protocol PokemonVM {
    var inventoryPublisher: Published<[PokemonCell.UIModel]>.Publisher { get }
    
    var searchQuery: String { get set }
    
    /// Asynchronously populates the full Pokémon list and triggers the publisher.
    func populate() async throws
    
    /// Retrieves detailed Pokémon data by its Pokédex ID.
    func getPokemonDetails(by id: Int) async throws -> PokemonDetailModel?
}

/// A view model responsible for managing the Pokémon list data,
/// including retrieval, transformation into UI models, and filtering.
class PokeDexListVM: PokemonVM, ObservableObject {
    var inventoryPublisher: Published<[PokemonCell.UIModel]>.Publisher { $filteredInventory }
    
    @Published var searchQuery: String = ""
    private let dataManager: PokemonDataManager
    @Published private var pokemonInventory = [PokemonCell.UIModel]()
    @Published private var filteredInventory = [PokemonCell.UIModel]()
    
    init(dataManager: PokemonDataManager) {
        self.dataManager = dataManager
        setupFiltering()
    }
    
    private func setupFiltering() {
        $pokemonInventory
            .combineLatest($searchQuery)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { items, query -> [PokemonCell.UIModel] in
                guard !query.isEmpty else { return items }
                return items.filter {
                    $0.name.lowercased().hasPrefix(query.lowercased()) ||
                    String($0.pokedexNumber).hasPrefix(query)
                }
            }
            .assign(to: &$filteredInventory)
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
