//
//  Sprites.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

// MARK: - Sprites
struct Sprites: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
