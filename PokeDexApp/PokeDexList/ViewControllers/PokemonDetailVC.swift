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
        view.backgroundColor = .blue
    }
}
