//
//  PokemonDetailVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit

class PokemonDetailVC: UIViewController {
    private let viewModel: PokemonDetailVM
    private var detailContentView: PokemonDetailContentView!
    
    init(viewModel: PokemonDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        detailContentView = PokemonDetailContentView()
        view = detailContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.configureNavigationBarAppearance(titleColor: #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1), largeTitleColor: #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1))
        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never
        
        // Configure the custom view with data from the view model
        guard let contentModel = viewModel.getPokemonDetails() else { return }
        detailContentView.configure(with: contentModel)
    }
}
