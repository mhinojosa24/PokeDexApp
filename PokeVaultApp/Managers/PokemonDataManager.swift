//
//  PokemonDataManager.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import Foundation
import SwiftData

/// `PokemonDataManager` manages Pokemon data persistence and retrieval.
/// It interacts with a `DataActorProtocol` for thread-safe data operations.
class PokemonDataManager {
    private let dataStore: DataActorProtocol

    /// Initializes a new instance of `PokemonDataManager` with the given actor.
    /// - Parameter dataActor: The data actor conforming to `DataActorProtocol`.
    init(dataStoreActor: DataActorProtocol) {
        self.dataStore = dataStoreActor
    }

    /// Saves a `PokemonDetailResponse` to the data store.
    /// If a Pokemon with the same ID already exists, it updates the existing record.
    /// - Parameter detail: The `PokemonDetailResponse` to be saved.
    func savePokemonDetail(_ detail: PokemonDetailResponse) async throws {
        let modelDetail = PokemonDetailMapper.map(detail)
        try await dataStore.save(modelDetail)
    }
    
    /// Fetches all `PokemonDetailModel` objects from the data store.
    /// - Returns: An array of `PokemonDetailModel` objects.
    func fetchAllPokemonDetails() async throws -> [PokemonDetailModel] {
        return try await dataStore.fetchAll()
    }

    func fetchPokemonDetail(byID id: Int) async throws -> PokemonDetailModel? {
        return try await dataStore.fetch(byID: id)
    }

    /// Clears all `PokemonDetailModel` objects from the data context.
    func clearInventory() async throws {
        try await dataStore.clearAll()
    }
    
    /// Checks if the context container has any stored objects.
    /// - Returns: `true` if the context container has stored objects, otherwise `false`.
    func isPokemonDataStoreEmpty() async throws -> Bool {
        return try await dataStore.isEmpty()
    }
}
