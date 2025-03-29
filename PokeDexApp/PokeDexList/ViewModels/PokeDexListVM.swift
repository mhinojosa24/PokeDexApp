//
//  PokeDexListVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import Foundation
protocol PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)? { get set }
    func populate() async throws
}


class PokeDexListVM: PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)?
    private(set) var pokemonDetailList: [PokemonDetail] = []
    
    private var pokemonInfoList: [PokemonCell.UIModel] = [] {
        didSet {
            publisher?(pokemonInfoList)
        }
    }
    
    func populate() async throws {
        do {
            let inventory = try PokemonDataManager.shared.getAllPokemonDetails()
            pokemonInfoList = inventory.map({ PokemonCell.UIModel(thumbnail: $0.sprite.officialArtwork,
                                                                  name: $0.name,
                                                                  pokedexNumber: $0.id,
                                                                  colorType: .customColor($0.species.color))
            })
        } catch {
            throw error
        }
    }
}
