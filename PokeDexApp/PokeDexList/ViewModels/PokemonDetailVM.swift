//
//  PokemonDetailVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import Foundation

protocol PokemonDetailVM {
    func getPokemonDetails() -> PokemonDetailView.UIModel?
}
    

class PokeDexDetailVM: PokemonDetailVM {
    
    var pokemonDetails: PokemonDetailModel
    
    init(_ pokemonDetails: PokemonDetailModel) {
        self.pokemonDetails = pokemonDetails
    }
    
    func getPokemonDetails() -> PokemonDetailView.UIModel? {
        guard let gifURL = URL(string: pokemonDetails.sprite.showdownGifURL) else { return nil }
        return PokemonDetailView.UIModel(pokemonGifURL: gifURL,
                                         name: pokemonDetails.name,
                                         description: pokemonDetails.flavorDescription,
                                         types: [],
                                         weaknesses: [])
    }
}

