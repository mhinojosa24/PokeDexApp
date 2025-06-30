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
class PokeDexListVC: UIViewController {
    private var viewModel: PokemonVM
    private var listView: PokeDexListView = .init()
    private lazy var dataSource: PokeDexListDataSource = .init(collectionView: listView.collectionView)
    private var cancellables = Set<AnyCancellable>()
    
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
    
    override func loadView() {
        super.loadView()
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        listView.collectionView.delegate = self
        setupPublishers()
        populateCollectionView()
    }
    
    /// Configures the navigation bar appearance, large title, and search bar.
    private func setupNavigationBar() {
        view.backgroundColor = PokemonBackgroundColor.icyWhite.color
        configureNavigationBar(
            style: .opaque,
            title: PokemonBackgroundColor.darkNavyBlue.color,
            largeTitle: PokemonBackgroundColor.darkNavyBlue.color,
            tint: PokemonBackgroundColor.darkNavyBlue.color,
            hidesSeparator: false,
            prefersLargeTitles: true,
            isTranslucent: true
        )
        
        navigationItem.searchController = listView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "PokéVault"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    /// Subscribes to view model publishers for UI updates (to be deprecated if using async data).
    private func setupPublishers() {
        viewModel.inventoryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] inventory in
                guard let self = self else { return }
                self.dataSource.apply(inventory)
            }
            .store(in: &cancellables)
        
        let textField = listView.searchController.searchBar.searchTextField
        let searchTextPublisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
        
        viewModel.inventoryPublisher
            .combineLatest(searchTextPublisher.prepend(""))
            .map { items, query -> [PokemonCell.UIModel] in
                guard !query.isEmpty else { return items }
                return items.filter { $0.name.lowercased().hasPrefix(query.lowercased())
                    || String($0.pokedexNumber).hasPrefix(query)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filtered in
                guard let self = self else { return }
                self.dataSource.applyFilter(filtered)
            }
            .store(in: &cancellables)
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
}


extension PokeDexListVC: UICollectionViewDelegate {
    /// Handles selection of a Pokémon cell and informs the delegate with its detailed info.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.dataSource.itemIdentifier(for: indexPath) {
            Task.detached(priority: .userInitiated) { [weak self] in
                guard let self = self else { return }
                do {
                    if let details = try await self.viewModel.getPokemonDetails(by: item.pokedexNumber) {
                        await MainActor.run {
                            self.delegate?.didSelectPokemon(details)
                        }
                    }
                } catch {
                    print("Detail fetch error", error)
                }
            }
        }
    }
}

