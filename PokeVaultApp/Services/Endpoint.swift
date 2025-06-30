//
//  Endpoint.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 6/30/25.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = .init()
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pokeapi.co"
        components.path = "/api/v2/" + path
        components.queryItems = queryItems
        return components.url!
    }
}

extension Endpoint {
    static func allPokemons(limit: Int = 1025) -> Endpoint {
        .init(path: "pokemon", queryItems: [
            .init(name: "offset", value: "0"),
            .init(name: "limit", value: "\(limit)")
        ])
    }
    
    static func pokemon(idOrName: String) -> Endpoint {
        .init(path: "pokemon/\(idOrName)")
    }
    
    static func pokemonSpecies(idOrName: String) -> Endpoint {
        .init(path: "pokemon-species/\(idOrName)")
    }
    
    static func type(idOrName: String) -> Endpoint {
        .init(path: "type/\(idOrName)")
    }
    
    static func evolutionChain(id: Int) -> Endpoint {
        .init(path: "evolution-chain/\(id)")
    }
}



