//
//  PokeDexListVC.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit
import Combine

/// The main list screen for the PokéDex app, displaying a searchable, scrollable
/// collection of Pokémon in a two-column grid layout.
///
/// This view controller:
/// - Initializes with a `PokemonVM` view model
/// - Uses a `UICollectionViewDiffableDataSource` for efficient UI updates
/// - Supports search through a custom `UISearchController`
/// - Notifies its delegate when a Pokémon is selected
class PokeDexListVC: UICollectionViewController {
    // MARK: - Properties
    private var viewModel: PokemonVM
    private var cancellables = Set<AnyCancellable>()
    weak var delegate: PokeDexDelegate?
    
    private lazy var searchController = UIComponentFactory.makeSearchController()
    private lazy var dataSource: PokeDexListDataSource = .init(collectionView: collectionView)
    
    // MARK: - Initializers
    init(viewModel: PokemonVM) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UIComponentFactory.configureCompositionalLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        setupBindings()
        fetchInitialData()
    }
    
    // MARK: - Configuration
    
    /// Configures the navigation bar appearance, large title, and search bar.
    private func configureNavigationBar() {
        title = "PokéVault"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        UIComponentFactory.configureNavigationBar(for: navigationItem, with: searchController)
    }
    
    /// Configures collection view.
    private func configureCollectionView() {
        collectionView.backgroundColor = PokemonBackgroundColor.icyWhite.color
        collectionView.indicatorStyle = .black
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
    }
    
    /// Subscribes to view model publishers for UI updates (to be deprecated if using async data).
    private func setupBindings() {
        viewModel.inventoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] inventory in
                guard let self = self else { return }
                self.dataSource.apply(inventory)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .compactMap { ($0.object as? UISearchTextField)?.text }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                self.viewModel.searchQuery = query
            }
            .store(in: &cancellables)
    }
    
    /// Triggers initial population of the Pokémon list from local or remote storage.
    private func fetchInitialData() {
        Task {
            do {
                try await viewModel.populate()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.dataSource.itemIdentifier(for: indexPath) {
            Task { [weak self] in
                guard let self = self else { return }
                do {
                    if let details = try await self.viewModel.getPokemonDetails(by: item.pokedexNumber) {
                        self.delegate?.didSelectPokemon(details)
                    }
                } catch {
                    print("Detail fetch error", error)
                }
            }
        }
    }
}
