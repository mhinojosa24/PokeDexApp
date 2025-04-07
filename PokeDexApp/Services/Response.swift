//
//  Response.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//


// MARK: - Response
struct Response: Decodable {
    let next: String?
    let results: [PokemonResponse]
}
