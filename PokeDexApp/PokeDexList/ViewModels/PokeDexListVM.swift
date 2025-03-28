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
    private let inventory: [PokemonDetailModel]
    private(set) var pokemonDetailList: [PokemonDetail] = []
    
    private var pokemonInfoList: [PokemonCell.UIModel] = [] {
        didSet {
            publisher?(pokemonInfoList)
        }
    }
    
    init(inventory: [PokemonDetailModel]) {
        self.inventory = inventory
    }
    
    func populate() async throws {
        do {
            // TODO: fetch all pokemon locally
            // TODO: map `PokemonDetailModel` => `PokemonCell.UIModel`
            // TODo: sort them?
            // TODO: assign fetched pokemons to `pokemonDetailList`
        } catch {
            throw error
        }
    }
}
