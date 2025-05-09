//
//  EvolutionInfoView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 5/1/25.
//

import UIKit

/// A vertical stack view that displays a Pokémon's evolution chain.
///
/// Each evolution stage includes:
/// - A vertical line + label showing the level at which the evolution occurs
/// - The Pokémon's image, Pokédex number, and name
///
/// The view is built dynamically from a sorted list of evolution data.
class EvolutionInfoView: UIStackView {
    /// A view model representing the evolution data for the Pokémon.
    struct UIModel {
        /// Represents a single evolution stage.
        struct EvolutionChain {
            let pokedexNumber: Int       // National Dex number
            let name: String             // Name of the Pokémon
            let thumbnail: String        // URL string for the thumbnail image
            let level: Int               // Level at which evolution occurs (0 = base form)
        }
        let themeColor: String           // Color used for theming (currently unused)
        let evolutions: [EvolutionChain] // List of all evolution stages
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
    
    /// Builds and lays out the evolution views based on the sorted evolution data.
    ///
    /// For each evolution stage:
    /// - If it's not the base form (level > 0), adds a vertical separator with the evolution level.
    /// - Adds an image, Pokédex number, and name label in a vertically stacked view.
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
                
                let pokemonLvlLabel = PDLabel(text: "Lv. \(evolution.level)", textColor: .darkNavyBlue, fontWeight: .light, fontSize: 14)
                
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
            let pokemonIdLabel = PDLabel(text: formattedNumber, textColor: .darkNavyBlue, fontWeight: .light, fontSize: 14)
            
            let pokemonNameLabel = PDLabel(text: evolution.name.capitalized, textColor: .darkNavyBlue, fontWeight: .semiBold, fontSize: 18)
            
            contentStack.addArrangedSubviews([thumbnail, pokemonIdLabel, pokemonNameLabel])
            addArrangedSubview(contentStack)
        }
    }
}
