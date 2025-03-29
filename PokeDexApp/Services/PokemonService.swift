//
//  PokemonService.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


/// `PokemonService` is a class responsible for fetching Pokemon data from the PokeAPI.
/// It uses an `APIClient` to perform network requests and handles parsing and saving
/// the fetched data.
class PokemonService {
    private let client: APIClient
    
    /// Initializes a new instance of `PokemonService` with the given API client.
   /// - Parameter client: The API client used to perform network requests.
    init(client: APIClient) {
        self.client = client
    }
    
    /// Fetches a list of Pokemons
    /// - Throws: An error if the URL is invalid or the network request fails.
    func fetchPokemons() async throws {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025") else {
            throw URLError(.badURL)
        }
        
        do {
            let dataTaskResult = try await client.fetchData(url)
            let parsedResult = try client.validateHTTPResponse(with: dataTaskResult)
            let response = try JSONDecoder().decode(Response.self, from: parsedResult)
            try await fetchPokemonDetails(from: response)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    /// Fetches the details of each Pokemon from the given response.
    /// - Parameter response: The response containing the list of Pokemons.
    /// - Throws: An error if the network request or parsing fails.
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
    
    /// Adds a task to the task group to fetch the details of a single Pokemon.
    /// - Parameters:
    ///   - taskGroup: The task group to add the task to.
    ///   - pokemon: The Pokemon to fetch the details for.
    fileprivate func handleTaskGroup(with taskGroup: inout TaskGroup<PokemonDetail?>, for pokemon: Pokemon) {
        taskGroup.addTask {
            do {
                guard let url = URL(string: pokemon.url) else { throw URLError(.badURL) }
                let parsedResponse = try self.client.validateHTTPResponse(with: try await self.client.fetchData(url))
                var pokemonDetail = try JSONDecoder().decode(PokemonDetail.self, from: parsedResponse)
                
                guard let speciesURL = URL(string: pokemonDetail.species.url) else { throw URLError(.badURL) }
                let speciesResponseData = try await self.client.fetchData(speciesURL)
                let parsedSpeciesResponse = try self.client.validateHTTPResponse(with: speciesResponseData)
                
                let speciesDetailResponse = try JSONDecoder().decode(SpeciesDetail.self, from: parsedSpeciesResponse)

                pokemonDetail.species.color = speciesDetailResponse.color
                return pokemonDetail
            } catch {
                return nil
            }
        }
    }
}
