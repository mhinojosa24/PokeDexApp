//
//  PokeDexListVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit

class PokeDexListVC: UIViewController {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Name or number"
        searchVC.searchBar.overrideUserInterfaceStyle = .light
        return searchVC
    }()
    
    private var viewModel: PokemonVM
    private var dataSource: PokeDexDiffableDataSource!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, PokemonCell.UIModel>()
    
    init(viewModel: PokemonVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayouts()
        setupPublishers()
        setupObservers()
        populateCollectionView()
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = .white
        navigationController?.configureNavigationBarAppearance(titleColor: #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1), largeTitleColor: #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1))
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.title = "PokéDex"
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupLayouts() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 17),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -17),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupObservers() {
        dataSource = PokeDexDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else { return UICollectionViewCell() }
            cell.configure(with: model)
            return cell
        })
    }
    
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
    
    private func populateCollectionView() {
        Task {
            do {
                try await viewModel.populate()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) {
            print(item)
        }
    }
}


extension PokeDexListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if let viewModel = viewModel as? PokeDexListVM {
            viewModel.filterPokemon(by: text)
        }
    }
}
