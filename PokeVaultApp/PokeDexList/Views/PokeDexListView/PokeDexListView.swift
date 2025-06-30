//
//  PokeDexListView.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 6/27/25.
//

import UIKit


final class PokeDexListView: UIView {
    // MARK: - Public subviews
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.indicatorStyle = .black
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.overrideUserInterfaceStyle = .light
        searchVC.searchBar.searchBarStyle = .prominent
        searchVC.searchBar.placeholder = "Name or number"
        searchVC.searchBar.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        searchVC.searchBar.searchTextField.layer.cornerRadius = 16
        searchVC.searchBar.searchTextField.clipsToBounds = true
        searchVC.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 16)
        if let leftImageView = searchVC.searchBar.searchTextField.leftView as? UIImageView {
            leftImageView.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        }
        return searchVC
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = PokemonBackgroundColor.icyWhite.color
        setupHierarchyAndConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchyAndConstraints() {
        addSubview(collectionView)
        collectionView.constrain([
            .top(targetAnchor: topAnchor),
            .leading(targetAnchor: leadingAnchor),
            .trailing(targetAnchor: trailingAnchor),
            .bottom(targetAnchor: bottomAnchor)
        ])
    }
    
    private func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
