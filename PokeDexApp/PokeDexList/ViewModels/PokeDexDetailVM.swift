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
                                                backgroundImageColor: .init(pokemonDetails.themeColor),
                                                name: pokemonDetails.name,
                                                description: pokemonDetails.flavorDescription,
                                                species: pokemonDetails.species,
                                                types: pokemonDetails.types.map { $0.name },
                                                weaknesses: pokemonDetails.weaknesses.map { $0.name },
                                                evolutions: pokemonDetails.evolution.map { $0.name },
                                                height: pokemonDetails.height,
                                                weight: pokemonDetails.weight,
                                                abilities: pokemonDetails.abilities,
                                                captureRate: pokemonDetails.catchRate,
                                                growthRate: pokemonDetails.growthRate,
                                                baseExperience: pokemonDetails.baseExperience)
    }
}

