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
            let pokedexNumber: Int
            let name: String
            let thumbnail: String
            let level: Int
        }
        let themeColor: String
        let evolutions: [EvolutionChain]
    }
    
    private var model: UIModel
    
    init(model: UIModel) {
        self.model = model
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        distribution = .equalCentering
        spacing = 16
        backgroundColor = .clear
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        for evolution in model.evolutions.sorted(by: { $0.level < $1.level }) {
            let contentStack = UIStackView()
            contentStack.axis = .vertical
            contentStack.alignment = .center
            contentStack.distribution = .fill
            contentStack.spacing = 4
            
            if evolution.level > 0 {
                let evolutionLevelSeparator = UIStackView()
                evolutionLevelSeparator.translatesAutoresizingMaskIntoConstraints = false
                evolutionLevelSeparator.axis = .vertical
                evolutionLevelSeparator.alignment = .center
                evolutionLevelSeparator.distribution = .fillEqually
                evolutionLevelSeparator.spacing = 17
                
                let topSpacer = UIView()
                topSpacer.translatesAutoresizingMaskIntoConstraints = false
                topSpacer.widthAnchor.constraint(equalToConstant: 2).isActive = true
                topSpacer.backgroundColor = UIColor.lightGray
                
                let pokemonLvlLabel = PDLabel(text: "Lv. \(evolution.level)", textColor: .black, fontWeight: .light, fontSize: 14)
                
                let bottomSpacer = UIView()
                bottomSpacer.translatesAutoresizingMaskIntoConstraints = false
                bottomSpacer.widthAnchor.constraint(equalToConstant: 2).isActive = true
                bottomSpacer.backgroundColor = UIColor.lightGray
                
                evolutionLevelSeparator.addArrangedSubviews([topSpacer, pokemonLvlLabel, bottomSpacer])
                
                evolutionLevelSeparator.heightAnchor.constraint(equalToConstant: 100).isActive = true
                addArrangedSubview(evolutionLevelSeparator)
            }
            
            let thumbnail = CustomImageView(frame: .zero, imageURLString: evolution.thumbnail)
            thumbnail.translatesAutoresizingMaskIntoConstraints = false
            thumbnail.contentMode = .scaleAspectFit
            thumbnail.backgroundColor = .clear
            thumbnail.heightAnchor.constraint(equalToConstant: 96).isActive = true
            thumbnail.widthAnchor.constraint(equalToConstant: 96).isActive = true
            
            let formattedNumber = String(format: "%03d", evolution.pokedexNumber)
            let pokemonIdLabel = PDLabel(text: formattedNumber, textColor: .black, fontWeight: .light, fontSize: 14)
            
            let pokemonNameLabel = PDLabel(text: evolution.name.capitalized, textColor: PokemonBackgroundColor(model.themeColor), fontWeight: .semiBold, fontSize: 18)
            
            contentStack.addArrangedSubviews([thumbnail, pokemonIdLabel, pokemonNameLabel])
            addArrangedSubview(contentStack)
        }
    }
}
