//
//  PokemonDetail.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

// MARK: - Pokemon Detail
struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
}
