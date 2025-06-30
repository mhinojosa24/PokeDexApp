//
//  DataStoreActor.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import Foundation
import SwiftData

/// `DataContextProtocol` is a protocol that defines the methods required for interacting
/// with a data context. It provides methods for saving, inserting, deleting, and fetching
/// data from the model context.
protocol DataActorProtocol {
    func save(_ detail: PokemonDetailModel) async throws
    func fetchAll() async throws -> [PokemonDetailModel]
    func fetch(byID id: Int) async throws -> PokemonDetailModel?
    func clearAll() async throws
    func isEmpty() async throws -> Bool
}

/// `DataStoreActor` is a class that conforms to the `DataContextProtocol` and provides
/// methods to interact with the SwiftData model container. It handles saving, inserting,
/// deleting, and fetching data from the model container.
actor DataStoreActor: DataActorProtocol, ModelActor {
    let modelContainer: ModelContainer
    let context: ModelContext
    nonisolated let modelExecutor: any ModelExecutor
    
    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        self.context = ModelContext(modelContainer)
        self.modelExecutor = DefaultSerialModelExecutor(modelContext: self.context)
    }
    
    func save(_ detail: PokemonDetailModel) async throws {
        let pokemonID = detail.id
        let descriptor = FetchDescriptor<PokemonDetailModel>(predicate: #Predicate { $0.id == pokemonID })
        let existingItems = try context.fetch(descriptor)
        
        if let existingItem = existingItems.first {
            existingItem.update(detail)
        } else {
            context.insert(detail)
        }
        try context.save()
    }
    
    func fetchAll() async throws -> [PokemonDetailModel] {
        let descriptor = FetchDescriptor<PokemonDetailModel>(sortBy: [SortDescriptor(\.id, order: .forward)])
        return try context.fetch(descriptor)
    }
    
    func fetch(byID id: Int) async throws -> PokemonDetailModel? {
        let descriptor = FetchDescriptor<PokemonDetailModel>(predicate: #Predicate { $0.id == id })
        let items = try context.fetch(descriptor)
        return items.first
    }
    
    func clearAll() async throws {
        try context.delete(model: PokemonDetailModel.self)
        try context.save()
    }
    
    /// Checks if the data store contains any records of the specified model type.
    /// - Returns: `true` if the store is empty for the given model type, `false` otherwise
    func isEmpty() async throws -> Bool {
        let descriptor = FetchDescriptor<PokemonDetailModel>()
        let count = try context.fetchCount(descriptor)
        return count == .zero
    }
}
