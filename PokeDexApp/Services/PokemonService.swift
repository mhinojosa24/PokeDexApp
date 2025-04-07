//
//  PokemonService.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


/// `PokemonService` is a class responsible for fetching PokemonResponse data from the PokeAPI.
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
        let url = try url(from: "https://pokeapi.co/api/v2/pokemon?offset=0&limit=50")
        let response: Response = try await client.fetch(url: url, as: Response.self)
        try await fetchPokemonDetails(from: response)
    }
    
    /// Fetches the details of each PokemonResponse from the given response.
    /// - Parameter response: The response containing the list of Pokemons.
    /// - Throws: An error if the network request or parsing fails.
    fileprivate func fetchPokemonDetails(from response: Response) async throws {
        let dataManager = PokemonDataManager.shared
        await withTaskGroup(of: PokemonDetailResponse?.self) { group in
            for pokemon in response.results {
                group.addTask { [weak self] in
                    guard let self = self else { return nil }
                    do {
                        return try await self.fetchPokemonDetail(for: pokemon)
                    } catch {
                        print("Failed to fetch detail for \(pokemon.name): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            
            for await detail in group {
                if let detail = detail {
                    dataManager.savePokemonDetail(detail)
                }
            }
        }
    }
    
    fileprivate func fetchPokemonDetail(for pokemon: PokemonResponse) async throws -> PokemonDetailResponse {
        let detailURL = try url(from: pokemon.url)
        var detail: PokemonDetailResponse = try await client.fetch(url: detailURL, as: PokemonDetailResponse.self)
        
        // Fetch species details separately and update the detail object
        let speciesURL = try url(from: detail.species.url)
        let speciesDetail: SpeciesDetailResponse = try await client.fetch(url: speciesURL, as: SpeciesDetailResponse.self)
        detail.species.detail = speciesDetail
        
        return detail
    }
    
    fileprivate func url(from string: String) throws -> URL {
        guard let url = URL(string: string) else { throw URLError(.badURL) }
        return url
    }
}
