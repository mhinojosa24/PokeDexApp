//
//  PokeDexListVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

/// A protocol that defines the interface for a Pokémon view model responsible for
/// fetching, filtering, and providing Pokémon list data for display.
protocol PokemonVM {
    /// Closure used to publish the full list of Pokémon UI models.
    var publisher: (([PokemonCell.UIModel]) -> Void)? { get set }
    
    /// Closure used to publish filtered Pokémon UI models (e.g. from search).
    var filterPublisher: (([PokemonCell.UIModel]) -> Void)? { get set }
    
    /// Asynchronously populates the full Pokémon list and triggers the publisher.
    func populate() async throws
    
    /// Filters Pokémon based on the provided search text and triggers the filter publisher.
    func filterPokemon(by searchText: String)
    
    /// Retrieves detailed Pokémon data by its Pokédex ID.
    func getPokemonInfo(by id: Int) async throws -> PokemonDetailModel?
}

/// A view model responsible for managing the Pokémon list data,
/// including retrieval, transformation into UI models, and filtering.
class PokeDexListVM: PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)?
    var filterPublisher: (([PokemonCell.UIModel]) -> Void)?
    
    /// Holds the detailed Pokémon responses fetched from storage.
    private(set) var pokemonDetailList: [PokemonDetailResponse] = []
    
    /// Stores the list of Pokémon UI models and triggers the publisher when changed.
    private var pokemonInfoList: [PokemonCell.UIModel] = [] {
        didSet {
            publisher?(pokemonInfoList)
        }
    }
    
    /// Fetches all stored Pokémon details, maps them into UI models,
    /// and publishes the list to update the UI.
    func populate() async throws {
        do {
            let inventory = try PokemonDataManager.shared.getAllPokemonDetails()
            pokemonInfoList = inventory.compactMap {
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
    
    /// Filters the Pokémon list based on the provided search text.
    /// If empty, publishes the full list. Otherwise, filters by name or ID prefix.
    func filterPokemon(by searchText: String) {
        guard !searchText.isEmpty else {
            filterPublisher?(pokemonInfoList)
            return
        }
        
        let filteredPokemon = pokemonInfoList.filter { model in
            return model.name.lowercased().hasPrefix(searchText.lowercased()) ||
                   String(model.pokedexNumber).hasPrefix(searchText)
        }
        
        filterPublisher?(filteredPokemon)
    }
    
    /// Retrieves a stored Pokémon detail by its ID from the data manager.
    ///
    /// - Parameter id: The Pokédex number of the Pokémon.
    /// - Returns: A `PokemonDetailModel` if found, otherwise nil.
    func getPokemonInfo(by id: Int) async throws -> PokemonDetailModel? {
        do {
            return try PokemonDataManager.shared.getPokemonDetail(by: id)
        } catch {
            throw error
        }
    }
}
