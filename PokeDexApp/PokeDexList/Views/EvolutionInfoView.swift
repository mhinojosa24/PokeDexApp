//
//  EvolutionInfoView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 5/1/25.
//

import UIKit

class EvolutionInfoView: UIStackView {
    struct UIModel {
        struct EvolutionChain {
            let id: Int
            let name: String
            let thumbnail: String
            let level: Int
        }
        let themeColor: String
        let evolutions: [EvolutionChain]
    }
    
    init(model: UIModel) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
