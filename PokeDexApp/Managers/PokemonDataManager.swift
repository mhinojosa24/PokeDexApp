//
//  PokemonDataManager.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import Foundation
import SwiftData

/// `PokemonDataManager` is a singleton class responsible for managing Pokemon data.
/// It provides methods to save, fetch, and clear `PokemonDetailModel` objects.
class PokemonDataManager {
    enum FetchDescriptorType {
        case all
        case limit(Int)
        case byID(Int)
        
        func fetchDescriptor() -> FetchDescriptor<PokemonDetailModel> {
                switch self {
                case .all:
                    return FetchDescriptor<PokemonDetailModel>(
                        predicate: nil,
                        sortBy: [SortDescriptor(\.id, order: .forward)]
                    )
                case .limit(let limit):
                    var fetchDescriptor = FetchDescriptor<PokemonDetailModel>(predicate: nil, sortBy: [])
                    fetchDescriptor.fetchLimit = limit
                    return fetchDescriptor
                case .byID(let id):
                    return FetchDescriptor<PokemonDetailModel>(
                        predicate: #Predicate { $0.id == id },
                        sortBy: []
                    )
            }
        }
    }
    
    static let shared = PokemonDataManager(context: DataContext())
    private let context: DataContextProtocol

    /// Initializes a new instance of `PokemonDataManager` with the given context.
    /// - Parameter context: The data context conforming to `DataContextProtocol`.
    init(context: DataContextProtocol) {
        self.context = context
    }

    /// Saves a `PokemonDetail` object to the data context.
    /// - Parameter detail: The `PokemonDetail` object to be saved.
    func savePokemonDetail(_ detail: PokemonDetailResponse) {
        let modelDetail = pokemonDetailModelFactory(pokemonDetail: detail)
        let fetchDescriptor = getFetchDescriptor(.byID(detail.id))
        
        do {
            let existingItems = try context.fetch(fetchDescriptor)
            if let existingItem = existingItems.first {
                existingItem.update(modelDetail)
            } else {
                try context.insert(modelDetail)
            }
        } catch {
            print("Failed to save PokemonDetail")
            print("Error: \(error.localizedDescription)")
        }
    }

    /// Fetches a `PokemonDetailModel` object by its ID.
    /// - Parameter id: The ID of the `PokemonDetailModel` to be fetched.
    /// - Returns: The `PokemonDetailModel` object if found, otherwise `nil`.
    func getPokemonDetail(by id: Int) throws -> PokemonDetailModel? {
        let fetchDescriptor = getFetchDescriptor(.byID(id))
        return try context.fetch(fetchDescriptor).first
    }

    /// Fetches all `PokemonDetailModel` objects.
    /// - Returns: An array of `PokemonDetailModel` objects.
    func getAllPokemonDetails() throws -> [PokemonDetailModel] {
        let fetchDescriptor = getFetchDescriptor(.all)
        return try context.fetch(fetchDescriptor)
    }

    /// Clears all `PokemonDetailModel` objects from the data context.
    func clearPokeDexInventory() {
        do {
            try context.deleteAll()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    /// Converts a `PokemonDetail` object to a `PokemonDetailModel` object.
    /// - Parameter pokemonDetail: The `PokemonDetail` object to be converted.
    /// - Returns: The corresponding `PokemonDetailModel` object.
    func pokemonDetailModelFactory(pokemonDetail: PokemonDetailResponse) -> PokemonDetailModel {
        let officialArtwork = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? ""
        let showdownGifURL = pokemonDetail.sprites.other?.showdown?.frontDefault ?? ""
        let themeColor = pokemonDetail.species.detail?.color.name ?? ""
        let flavorDescription = pokemonDetail.species.detail?.flavorTextEntries?.first(where: { $0.version.name == "ruby" })?.flavorText ?? ""
        let sprite = SpriteModel(officialArtwork: officialArtwork,
                                 showdownGifURL: showdownGifURL)
        
        let stats = pokemonDetail.stats.map { StatModel(name: $0.stat.name,
                                                   baseStat: $0.baseStat,
                                                   effort: $0.effort)
        }
        
        let types = pokemonDetail.types.compactMap { TypeModel(name: $0.type.name) }
        let weaknesses = pokemonDetail.weaknessTypes?.compactMap { TypeModel(name: $0) } ?? []
        let evolution = pokemonDetail.evolutionChain?.compactMap { EvolutionModel(name: $0.artwork) } ?? []
        
        return PokemonDetailModel(id: pokemonDetail.id,
                                  name: pokemonDetail.name,
                                  sprite: sprite,
                                  themeColor: themeColor,
                                  flavorDescription: flavorDescription,
                                  stats: stats,
                                  types: types,
                                  weaknesses: weaknesses,
                                  evolution: evolution,
                                  weight: pokemonDetail.weight)
    }
    
    /// Checks if the context container has any stored objects.
    /// - Returns: `true` if the context container has stored objects, otherwise `false`.
    func hasStoredItems() -> Bool {
        let fetchDescriptor = getFetchDescriptor(.limit(1))
        do {
            return try !context.fetch(fetchDescriptor).isEmpty
        } catch {
            print("Failed to fetch PokemonDetails: \(error)")
            return false
        }
    }
    
    fileprivate func getFetchDescriptor(_ type: FetchDescriptorType) -> FetchDescriptor<PokemonDetailModel> {
        return type.fetchDescriptor()
    }
}
