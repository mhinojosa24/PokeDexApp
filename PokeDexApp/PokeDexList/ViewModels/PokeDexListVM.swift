//
//  PokeDexListVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

protocol PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)? { get set }
    var filterPublisher: (([PokemonCell.UIModel]) -> Void)? { get set }
    func populate() async throws
    func filterPokemon(by searchText: String)
    func getPokemonInfo(by id: Int) async throws -> PokemonDetailModel?
}

class PokeDexListVM: PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)?
    var filterPublisher: (([PokemonCell.UIModel]) -> Void)?
    private(set) var pokemonDetailList: [PokemonDetailResponse] = []
    
    private var pokemonInfoList: [PokemonCell.UIModel] = [] {
        didSet {
            publisher?(pokemonInfoList)
        }
    }
    
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
    
    // This method filters the Pokémon based on the search query
    func filterPokemon(by searchText: String) {
        guard !searchText.isEmpty else {
            filterPublisher?(pokemonInfoList) // If search text is empty, return all data
            return
        }
        
        let filteredPokemon = pokemonInfoList.filter { model in
            // Check if the search text matches name or pokedex number
            return model.name.lowercased().hasPrefix(searchText.lowercased()) ||
            String(model.pokedexNumber).hasPrefix(searchText)
        }
        
        filterPublisher?(filteredPokemon)
    }
    
    func getPokemonInfo(by id: Int) async throws -> PokemonDetailModel? {
        do {
            return try PokemonDataManager.shared.getPokemonDetail(by: id)
        } catch {
            throw error
        }
    }
}
