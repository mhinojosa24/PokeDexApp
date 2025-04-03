//
//  PokemonDetailVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit

class PokemonDetailVC: UIViewController {
    private let viewModel: PokemonDetailVM
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    init(viewModel: PokemonDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.configureNavigationBarAppearance(titleColor: #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1), largeTitleColor: #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1))
        navigationItem.title = viewModel.pokemonDetails.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupLayouts() {
        tableView.constrain(to: view, edges: [
            .top(.zero),
            .leading(.zero),
            .trailing(.zero),
            .bottom(.zero)
        ])
    }
}
