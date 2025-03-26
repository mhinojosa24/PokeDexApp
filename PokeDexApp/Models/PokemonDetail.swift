//
//  PokemonDetail.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

// MARK: - Pokemon
struct PokemonDetail: Decodable, Hashable {
    let id: Int
    let name: String
    let sprites: Sprites
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PokemonDetail, rhs: PokemonDetail) -> Bool {
        return lhs.id == rhs.id
    }
}
