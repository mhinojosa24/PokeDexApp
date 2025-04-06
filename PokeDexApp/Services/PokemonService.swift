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
        do {
            let url = try self.url(from: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=50")
            let dataTaskResult = try await client.fetchData(url)
            let parsedResult = try client.validateHTTPResponse(with: dataTaskResult)
            let response = try JSONDecoder().decode(Response.self, from: parsedResult)
            try await fetchPokemonDetails(from: response)
        } catch {
            throw error
        }
    }
    
    /// Fetches the details of each Pokemon from the given response.
    /// - Parameter response: The response containing the list of Pokemons.
    /// - Throws: An error if the network request or parsing fails.
    fileprivate func fetchPokemonDetails(from response: Response) async throws {
        let dataManager = PokemonDataManager.shared
        await withTaskGroup(of: PokemonDetailResponse?.self) { group in
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
    fileprivate func handleTaskGroup(with taskGroup: inout TaskGroup<PokemonDetailResponse?>, for pokemon: Pokemon) {
        taskGroup.addTask {
            do {
                return try await self.fetchPokemonDetail(for: pokemon)
            } catch {
                print("Failed to fetch: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    fileprivate func fetchPokemonDetail(for pokemon: Pokemon) async throws -> PokemonDetailResponse {
        let detailURL = try url(from: pokemon.url)
        let detailData = try await client.fetchData(detailURL)
        let detailParsed = try client.validateHTTPResponse(with: detailData)
        var detail = try JSONDecoder().decode(PokemonDetailResponse.self, from: detailParsed)

        let speciesURL = try url(from: detail.species.url)
        let speciesData = try await client.fetchData(speciesURL)
        let speciesParsed = try client.validateHTTPResponse(with: speciesData)
        detail.species.detail = try JSONDecoder().decode(SpeciesDetailResponse.self, from: speciesParsed)

        return detail
    }
    
    fileprivate func url(from string: String) throws -> URL {
        guard let url = URL(string: string) else { throw URLError(.badURL) }
        return url
    }
}
