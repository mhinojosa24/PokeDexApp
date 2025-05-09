//
//  PokeDexListVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit

/// The main list screen for the PokéDex app, displaying a searchable, scrollable
/// collection of Pokémon in a two-column grid layout.
///
/// This view controller:
/// - Initializes with a `PokemonVM` view model
/// - Uses a `UICollectionViewDiffableDataSource` for efficient UI updates
/// - Supports search through a custom `UISearchController`
/// - Notifies its delegate when a Pokémon is selected
class PokeDexListVC: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.overrideUserInterfaceStyle = .light
        searchVC.searchBar.searchBarStyle = .prominent
        searchVC.searchBar.placeholder = "Name or number"
        searchVC.searchBar.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        searchVC.searchBar.searchTextField.layer.cornerRadius = 16
        searchVC.searchBar.searchTextField.clipsToBounds = true
        searchVC.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)

        // Style the left image view (magnifying glass)
        if let leftImageView = searchVC.searchBar.searchTextField.leftView as? UIImageView {
            leftImageView.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        }
        return searchVC
    }()
    
    private var viewModel: PokemonVM
    private var dataSource: PokeDexDiffableDataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonCell.UIModel>()
    
    weak var delegate: PokeDexDelegate?
    
    init(viewModel: PokemonVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
        setupPublishers()
        setupObservers()
        populateCollectionView()
    }
    
    /// Configures the navigation bar appearance, large title, and search bar.
    private func setupNavigationBar() {
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        configureNavigationBar(
            style: .opaque,
            title: PokemonBackgroundColor.darkNavyBlue.color,
            largeTitle: PokemonBackgroundColor.darkNavyBlue.color,
            tint: PokemonBackgroundColor.darkNavyBlue.color,
            hidesSeparator: false,
            prefersLargeTitles: true,
            isTranslucent: true
        )
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "PokéVault"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    /// Lays out the collection view and pins it to the view edges with padding.
    private func setupLayouts() {
        view.addSubview(collectionView)
        collectionView.constrain([
            .top(targetAnchor: view.topAnchor),
            .leading(targetAnchor: view.leadingAnchor, constant: 17),
            .trailing(targetAnchor: view.trailingAnchor, constant: 17),
            .bottom(targetAnchor: view.bottomAnchor, constant: 0)
        ])
    }
    
    /// Configures the diffable data source for the collection view.
    private func setupObservers() {
        dataSource = PokeDexDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else { return UICollectionViewCell() }
            cell.configure(with: model)
            return cell
        })
    }
    
    /// Subscribes to view model publishers for UI updates (to be deprecated if using async data).
    private func setupPublishers() {
        viewModel.publisher = { [weak self] pokemons in
            guard let self = self else { return }
            self.applySnapshot(with: pokemons)
        }
        
        viewModel.filterPublisher = { [weak self] pokemons in
            guard let self = self else { return }
            self.applyFilter(with: pokemons)
        }
    }
    
    
    /// Applies a diffable snapshot to update visible Pokémon list.
    private func applySnapshot(with pokemons: [PokemonCell.UIModel]) {
        guard dataSource != nil else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.snapshot.sectionIdentifiers.isEmpty {
                self.snapshot.appendSections([.main])
            }
            self.snapshot.appendItems(pokemons, toSection: .main)
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
        }
    }
    
    /// Applies a filtered snapshot when the user searches for a Pokémon.
    private func applyFilter(with pokemons: [PokemonCell.UIModel]) {
        guard dataSource != nil else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var newSnapshot = NSDiffableDataSourceSnapshot<Section, PokemonCell.UIModel>()
            newSnapshot.appendSections([.main])
            newSnapshot.appendItems(pokemons, toSection: .main)
            self.dataSource.apply(newSnapshot, animatingDifferences: true)
        }
        
    }
    
    /// Triggers initial population of the Pokémon list from local or remote storage.
    private func populateCollectionView() {
        Task {
            do {
                try await viewModel.populate()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Returns a compositional layout with 2 columns of Pokémon cards.
    private func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        // 1 item per row
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // Add padding
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        // 2 columns
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.35/5)) // 2/7
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        // Section
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}


extension PokeDexListVC: UICollectionViewDelegate {
    /// Handles selection of a Pokémon cell and informs the delegate with its detailed info.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            Task {
                do {
                    guard let pokemonDetail = try await viewModel.getPokemonInfo(by: item.pokedexNumber) else { return }
                    delegate?.didSelectPokemon(pokemonDetail)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


extension PokeDexListVC: UISearchResultsUpdating {
    /// Filters Pokémon based on the text input in the search bar.
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.filterPokemon(by: text)
    }
}
