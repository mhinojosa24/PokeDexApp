//
//  PokemonService.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


// MARK: - Pokemon Service
class PokemonService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    private func fetchPokemonsHelper(from urlString: String) async throws -> Response {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let parsedResponse = try client.parseHTTPResponse(
            response: try await client.fetchData(url)
        )
        return try JSONDecoder().decode(Response.self, from: parsedResponse)
    }
    
    func fetchPokemons() async throws -> Response {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=1025"
        return try await fetchPokemonsHelper(from: urlString)
    }
    
    func fetchPokemonDetail(_ urlString: String) async throws -> PokemonDetail {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let parsedResponse = try client.parseHTTPResponse(
            response: try await client.fetchData(url)
        )
        return try JSONDecoder()
            .decode(PokemonDetail.self, from: parsedResponse)
    }
}
