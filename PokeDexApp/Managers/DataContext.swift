//
//  DataContext.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import SwiftData

/// `DataContextProtocol` is a protocol that defines the methods required for interacting
/// with a data context. It provides methods for saving, inserting, deleting, and fetching
/// data from the model context.
protocol DataContextProtocol {
    func save() throws
    func insert<T: PokemonDetailModel>(_ object: T)
    func delete<T: PokemonDetailModel>(_ object: T)
    func fetch<T: PokemonDetailModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]
}

/// `DataContext` is a class that conforms to the `DataContextProtocol` and provides
/// methods to interact with the SwiftData model container. It handles saving, inserting,
/// deleting, and fetching data from the model container.
class DataContext: DataContextProtocol {
    private let container: ModelContainer

    /// Initializes a new instance of `DataContext`.
    /// This initializer sets up the model container with the schema for `PokemonDetailModel`.
    init() {
        do {
            let schema = Schema([ PokemonDetailModel.self ])
            let modelConfiguration = ModelConfiguration(schema: schema)
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }

    /// Provides the current model context.
    private var context: ModelContext {
        return ModelContext(container)
    }

    /// Saves the current state of the model context.
    /// - Throws: An error if the save operation fails.
    func save() throws {
        try context.save()
    }

    /// Inserts a new object into the model context.
    /// - Parameter object: The object to be inserted.
    func insert<T: PokemonDetailModel>(_ object: T) {
        context.insert(object)
    }
    
    /// Deletes an object from the model context.
    /// - Parameter object: The object to be deleted.
    func delete<T: PokemonDetailModel>(_ object: T) {
        context.delete(object)
    }

    /// Fetches objects from the model context based on the provided fetch descriptor.
    /// - Parameter fetchDescriptor: The descriptor that specifies the fetch request.
    /// - Returns: An array of objects that match the fetch request.
    /// - Throws: An error if the fetch operation fails.
    func fetch<T: PokemonDetailModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T] {
        return try context.fetch(fetchDescriptor)
    }
}
