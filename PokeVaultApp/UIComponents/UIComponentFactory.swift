//
//  UIComponentFactory.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 7/19/25.
//

import UIKit

struct UIComponentFactory {
    static func makeSearchController() -> UISearchController {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.overrideUserInterfaceStyle = .light
        searchVC.searchBar.searchBarStyle = .prominent
        searchVC.searchBar.placeholder = "Name or number"
        searchVC.searchBar.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        searchVC.searchBar.searchTextField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.01)
        searchVC.searchBar.searchTextField.layer.cornerRadius = 10
        searchVC.searchBar.searchTextField.clipsToBounds = true
        searchVC.searchBar.searchTextField.font = UIFont.init(name: PoppinsFontWeight.light.rawValue, size: 16)
        if let leftImageView = searchVC.searchBar.searchTextField.leftView as? UIImageView {
            leftImageView.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        }
        return searchVC
    }
    
    static func configureNavigationBar(for navigationItem: UINavigationItem, with searchController: UISearchController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.backgroundEffect = UIBlurEffect(style: .light)
        appearance.titleTextAttributes = [
            .foregroundColor: PokemonBackgroundColor.darkNavyBlue.color,
            .font: UIFont(name: PoppinsFontWeight.semiBold.rawValue, size: 17)!
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: PokemonBackgroundColor.darkNavyBlue.color,
            .font: UIFont(name: PoppinsFontWeight.semiBold.rawValue, size: 34)!
        ]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.largeTitleDisplayMode = .inline
        navigationItem.searchController = searchController
        navigationItem.searchController?.isActive = false
        navigationItem.searchController?.searchBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    static func configureCompositionalLayout() -> UICollectionViewCompositionalLayout {
        // 1 item per row
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        // Add padding
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        // 2 columns
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.35/5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
