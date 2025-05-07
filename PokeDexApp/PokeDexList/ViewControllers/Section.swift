//
//  Section.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/26/25.
//

/// Represents the primary section used in the diffable data source for the collection view.
///
/// Currently, the app supports a single section (`main`) that holds all Pokémon cells.
/// This enum enables scalability if additional sections (e.g., favorites, recent, etc.)
/// are added in the future.
enum Section {
    case main
}
