//
//  PokemonDataManager.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import SwiftData
import Foundation

/// `PokemonDataManager` is a singleton class responsible for managing Pokemon data.
/// It provides methods to save, fetch, and clear `PokemonDetailModel` objects.
class PokemonDataManager {
    static let shared = PokemonDataManager(context: DataContext())
    private let context: DataContextProtocol

    /// Initializes a new instance of `PokemonDataManager` with the given context.
    /// - Parameter context: The data context conforming to `DataContextProtocol`.
    init(context: DataContextProtocol) {
        self.context = context
    }

    /// Saves a `PokemonDetail` object to the data context.
    /// - Parameter detail: The `PokemonDetail` object to be saved.
    func savePokemonDetail(_ detail: PokemonDetail) {
        let modelDetail = pokemonDetailModelFactory(pokemonDetail: detail)
        context.insert(modelDetail)
        do {
            try context.save()
        } catch {
            print("Failed to save PokemonDetail: \(error)")
        }
    }

    /// Fetches a `PokemonDetailModel` object by its ID.
    /// - Parameter id: The ID of the `PokemonDetailModel` to be fetched.
    /// - Returns: The `PokemonDetailModel` object if found, otherwise `nil`.
    func getPokemonDetail(by id: Int) -> PokemonDetailModel? {
        var fetchDescriptor = FetchDescriptor<PokemonDetailModel>(
            predicate: #Predicate<PokemonDetailModel> { $0.id == id },
            sortBy: []
        )
        
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Failed to fetch PokemonDetail: \(error)")
            return nil
        }
    }

    /// Fetches all `PokemonDetailModel` objects.
    /// - Returns: An array of `PokemonDetailModel` objects.
    func getAllPokemonDetails() -> [PokemonDetailModel] {
        var fetchDescriptor = FetchDescriptor<PokemonDetailModel>(
            predicate: nil,
            sortBy: [.init(\.id)]
        )
        
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch PokemonDetails: \(error)")
            return []
        }
    }

    /// Clears all `PokemonDetailModel` objects from the data context.
    func clearAllPokemonDetails() {
        var fetchDescriptor = FetchDescriptor<PokemonDetailModel>(
            predicate: nil,
            sortBy: []
        )
        
        do {
            let pokemonDetails = try context.fetch(fetchDescriptor)
            for detail in pokemonDetails {
                context.delete(detail)
            }
            try context.save()
        } catch {
            print("Failed to clear PokemonDetails: \(error)")
        }
    }
    
    /// Converts a `PokemonDetail` object to a `PokemonDetailModel` object.
    /// - Parameter pokemonDetail: The `PokemonDetail` object to be converted.
    /// - Returns: The corresponding `PokemonDetailModel` object.
    private func pokemonDetailModelFactory(pokemonDetail: PokemonDetail) -> PokemonDetailModel {
        let officialArtwork = pokemonDetail.sprites.other?.officialArtwork.frontDefault ?? ""
        let showdownGifURL = pokemonDetail.sprites.showdown?.frontDefault ?? ""
        
        let sprite = SpriteModel(officialArtwork: officialArtwork, showdownGifURL: showdownGifURL)
        
        let stats = pokemonDetail.stats.map { StatModel(name: $0.stat.name,
                                                   baseStat: $0.baseStat,
                                                   effort: $0.effort)
        }
        
        let types = pokemonDetail.types.map { PokemonTypeModel(name: $0.name ?? "", iconURL: $0.url ?? "") }
        
        return PokemonDetailModel(id: pokemonDetail.id,
                                  name: pokemonDetail.name,
                                  sprite: sprite,
                                  stats: stats,
                                  types: types,
                                  weight: pokemonDetail.weight)
    }
}
