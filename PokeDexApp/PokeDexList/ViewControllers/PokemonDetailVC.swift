//
//  PokemonDetailVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit

class PokemonDetailVC: UIViewController {
    private let viewModel: PokemonDetailVM
    
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
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        setupLayouts()
    }
    
    private func setupLayouts() {
        guard let pokemonDetail = viewModel.getPokemonDetails() else { return }
        let model = PokemonDetailView.UIModel(pokemonGifURL: pokemonDetail.pokemonGifURL,
                                              name: pokemonDetail.name,
                                              description: pokemonDetail.description,
                                              types: pokemonDetail.types,
                                              weaknesses: pokemonDetail.weaknesses)
        let pokemonDetailView = PokemonDetailView(model: model)
        pokemonDetailView.constrain(to: view, edges: [
            .top(0),
            .leading(0),
            .trailing(0),
            .bottom(0)
        ])
    }
}
