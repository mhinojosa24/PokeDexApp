//
//  PokeDexDiffableDataSource.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import UIKit

/// `PokeDexListDataSource` manages the data source for a `UICollectionView`
/// using `UICollectionViewDiffableDataSource`.
///
/// This class provides a type-safe and efficient way to update the collection view's content
/// with animations by leveraging the diffable data source framework. It encapsulates
/// the logic for applying snapshots, making it easier to manage the collection view's data presentation.
///
/// **Usage:**
/// 1. Initialize with the `UICollectionView` to be managed.
/// 2. Call `apply(_:)` or `applyFilter(_:)` to update the data displayed in the collection view.
/// 3. The `dataSource` property can be accessed if needed for advanced customization,
///    but direct manipulation of the `snapshot` is generally handled internally by this class.
final class PokeDexListDataSource {

    // MARK: - Section Identifiers

    /// Defines the section identifiers used in the collection view's diffable data source.
    enum Section: Hashable {
        case main
    }

    // MARK: - Properties

    /// The underlying diffable data source responsible for managing the collection view's data
    /// and providing cells based on the applied snapshots.
    ///
    /// This property conforms to `UICollectionViewDataSource` and handles the necessary
    /// protocol methods behind the scenes. {Link: See also https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource-9tqpa}
    let dataSource: UICollectionViewDiffableDataSource<Section, PokemonCell.UIModel>

    // MARK: - Initialization

    /// Creates a new instance of `PokeDexListDataSource` associated with the specified collection view.
    ///
    /// The diffable data source is initialized with a cell provider closure that configures
    /// and returns `PokemonCell` instances for each item in the data source.
    ///
    /// - Parameter collectionView: The `UICollectionView` instance that this data source will manage.
    init(collectionView: UICollectionView) {
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        })
    }

    // MARK: - Data Updates

    /// Applies a new set of items to the collection view's data source.
    ///
    /// This method updates the internal snapshot with the provided items and applies
    /// the changes to the `dataSource` with animated differences. If the snapshot
    /// is initially empty, it appends the `.main` section. Subsequent calls will
    /// append items to the existing snapshot, effectively adding them to the collection view.
    ///
    /// - Parameter items: An array of `PokemonCell.UIModel` objects representing the data
    ///   to be displayed in the collection view.
    func apply(_ items: [PokemonCell.UIModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonCell.UIModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

