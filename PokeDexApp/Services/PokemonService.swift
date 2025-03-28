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
    
    func fetchPokemons(from urlString: String) async throws {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025") else {
            throw URLError(.badURL)
        }
        
        do {
            let dataTaskResult = try await client.fetchData(url)
            let parsedResult = try client.parseHTTPResponse(with: dataTaskResult)
            let response = try JSONDecoder().decode(Response.self, from: parsedResult)
            try await fetchPokemonDetails(from: response)
        } catch {
            throw error
        }
    }
    
    fileprivate func fetchPokemonDetails(from response: Response) async throws {
        let dataManager = PokemonDataManager.shared
        await withTaskGroup(of: PokemonDetail?.self) { [weak self] group in
            guard let self = self else { return }
            
            response.results.forEach { [weak self] pokemon in
                guard let self = self else { return }
                self.handleTaskGroup(with: &group, for: pokemon)
            }
            
            for await pokemonDetail in group {
                if let detail = pokemonDetail {
                    dataManager.savePokemonDetail(detail)
                }
            }
        }
    }
    
    fileprivate func handleTaskGroup(with taskGroup: inout TaskGroup<PokemonDetail?>, for pokemon: Pokemon) {
        taskGroup.addTask {
            do {
                guard let url = URL(string: pokemon.url) else { throw URLError(.badURL) }
                let parsedResponse = try self.client.parseHTTPResponse(with: try await self.client.fetchData(url))
                return try JSONDecoder().decode(PokemonDetail.self, from: parsedResponse)
            } catch {
                return nil
            }
        }
    }
}
