//
//  PokemonDetailVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import Foundation

protocol PokemonDetailVM {
    func getPokemonDetails() -> PokemonDetailContentView.UIModel?
}
    

class PokeDexDetailVM: PokemonDetailVM {
    
    var pokemonDetails: PokemonDetailModel
    
    init(_ pokemonDetails: PokemonDetailModel) {
        self.pokemonDetails = pokemonDetails
    }
    
    func getPokemonDetails() -> PokemonDetailContentView.UIModel? {
        return PokemonDetailContentView.UIModel(pokemonImageURLString: pokemonDetails.sprite.artwork,
                                                backgroundImageColor: .customColor(pokemonDetails.themeColor),
                                                name: pokemonDetails.name,
                                                description: pokemonDetails.flavorDescription,
                                                types: pokemonDetails.types,
                                                weaknesses: [],
                                                evolutions: [])
    }
}

