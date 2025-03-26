//
//  PokeDexListVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit

class PokeDexListVC: UIViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.bounces = false
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Name or number"
        searchVC.searchBar.overrideUserInterfaceStyle = .light
        return searchVC
    }()
    
    private var viewModel: PokemonVM
    
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
    }
    
    private func setupNavigationBar() {
        title = "PokéDex"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupLayouts() {
        view .addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

