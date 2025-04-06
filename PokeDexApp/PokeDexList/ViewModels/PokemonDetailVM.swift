//
//  PokemonDetailVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import Foundation

protocol PokemonDetailVM {
    func getPokemonDetails()
}
    

class PokeDexDetailVM: PokemonDetailVM {
    
    var pokemonDetails: PokemonDetailModel
    
    init(_ pokemonDetails: PokemonDetailModel) {
        self.pokemonDetails = pokemonDetails
    }
    
    func getPokemonDetails()  {
//        let gifURL = URL(string: pokemonDetails.sprite.showdownGifURL)!
//        return PokemonDetailView.UIModel(pokemonGifURL: gifURL,
//                                  name: pokemonDetails.name,
//                                  description: pokemonDetails.flavorDescription,
//                                  types: pokemonDetails.types.compactMap({ $0.iconURL }),
//                                  weaknesses: pokemonDetails.sprite.evolutionURLS)
    }
}

