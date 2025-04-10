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
        // TODO: - fix navigation UI
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        setupPokemonDetailContentView()
    }
    
    private func setupPokemonDetailContentView() {
        guard let model = viewModel.getPokemonDetails() else { return }
        let detailContentView = PokemonDetailContentView(model: model)
        view.addSubview(detailContentView)
        detailContentView.constrain(to: view, edges: [
            .top(0),
            .leading(0),
            .trailing(0),
            .bottom(0)
        ], useSafeArea: false)
    }
}
