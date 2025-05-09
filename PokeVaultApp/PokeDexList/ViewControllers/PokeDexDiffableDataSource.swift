//
//  PokeDexDiffableDataSource.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import UIKit

/// A custom `UICollectionViewDiffableDataSource` implementation that manages
/// a collection view displaying Pokémon cells in a Pokédex list.
///
/// This class defines how to associate a given `PokemonCell.UIModel` with its
/// corresponding section and cell configuration. It provides diffable snapshot
/// support for efficiently updating and animating the collection view content.
///
/// - Note: The data source expects sections to be of type `Section`, and
///   items to be of type `PokemonCell.UIModel`.
class PokeDexDiffableDataSource: UICollectionViewDiffableDataSource<Section, PokemonCell.UIModel> {}
