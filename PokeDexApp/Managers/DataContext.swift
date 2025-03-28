//
//  DataContext.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import Foundation
import SwiftData

/// `DataContextProtocol` is a protocol that defines the methods required for interacting
/// with a data context. It provides methods for saving, inserting, deleting, and fetching
/// data from the model context.
protocol DataContextProtocol {
    func save() throws
    func insert(_ object: PokemonDetailModel) throws
    func delete(_ object: PokemonDetailModel) throws
    func deleteAll() throws
    func fetch(_ fetchDescriptor: FetchDescriptor<PokemonDetailModel>) throws -> [PokemonDetailModel]
}

/// `DataContext` is a class that conforms to the `DataContextProtocol` and provides
/// methods to interact with the SwiftData model container. It handles saving, inserting,
/// deleting, and fetching data from the model container.
class DataContext: DataContextProtocol {
    private let container: ModelContainer
    private let context: ModelContext

    /// Initializes a new instance of `DataContext`.
    /// This initializer sets up the model container with the schema for `PokemonDetailModel`.
    init() {
        do {
            let schema = Schema([ PokemonDetailModel.self ])
            let modelConfiguration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            context = ModelContext(container)
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
//
//    /// Provides the current model context.
//    private var context: ModelContext {
//        return ModelContext(container)
//    }

    /// Saves the current state of the model context.
    /// - Throws: An error if the save operation fails.
    func save() throws {
        try context.save()
    }

    /// Inserts a new `PokemonDetailModel` object into the model context.
    /// If an object with the same ID already exists, it updates the existing object.
    /// - Parameter object: The `PokemonDetailModel` object to be inserted or updated.
    /// - Throws: An error if the insert or update operation fails.
    func insert(_ object: PokemonDetailModel) throws {
        context.insert(object)
        try save()
    }
    
    /// Deletes a specific `PokemonDetailModel` object from the model context.
    /// - Parameter object: The `PokemonDetailModel` object to be deleted.
    /// - Throws: An error if the delete operation fails.
    func delete(_ object: PokemonDetailModel) throws {
        do {
            context.delete(object)
            try save()
        } catch {
            print("Failed to delete object: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Deletes all objects of type `PokemonDetailModel` from the model context.
    /// - Throws: An error if the delete operation fails.
    func deleteAll() throws {
        do {
            try context.delete(model: PokemonDetailModel.self)
            try save()
        } catch {
            throw NSError(domain: "Failed to delete all objects", code: 0)
        }
    }

    /// Fetches objects from the model context based on the provided fetch descriptor.
    /// - Parameter fetchDescriptor: The descriptor that specifies the fetch request.
    /// - Returns: An array of objects that match the fetch request.
    /// - Throws: An error if the fetch operation fails.
    func fetch(_ fetchDescriptor: FetchDescriptor<PokemonDetailModel>) throws -> [PokemonDetailModel] {
        return try context.fetch(fetchDescriptor)
    }
}
