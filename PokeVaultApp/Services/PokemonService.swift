//
//  PokemonService.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


/// `PokemonService` is a class responsible for fetching PokemonResponse data from the PokeAPI.
/// It uses an `APIClient` to perform network requests and handles parsing and saving
/// the fetched data.
class PokemonService {
    private let client: APIClient
    private let dataManager: PokemonDataManager
    
    /// Initializes a new instance of `PokemonService` with the given API client.
   /// - Parameter client: The API client used to perform network requests.
    init(client: APIClient, dataManager: PokemonDataManager) {
        self.client = client
        self.dataManager = dataManager
    }
    
    /// Fetches a list of Pokemons
    /// - Throws: An error if the URL is invalid or the network request fails.
    func fetchAndSaveAllPokemonsDetails() async throws {
        let response: Response = try await client.fetch(url: Endpoint.allPokemons().url, as: Response.self)
        try await fetchAndSavePokemonDetails(from: response)
    }
    
    /// Fetches the details of each PokemonResponse from the given response.
    /// - Parameter response: The response containing the list of Pokemons.
    /// - Throws: An error if the network request or parsing fails.
    fileprivate func fetchAndSavePokemonDetails(from response: Response) async throws {
        await withTaskGroup(of: PokemonDetailResponse?.self) { group in
            for pokemon in response.results {
                group.addTask { [weak self] in
                    guard let self = self else { return nil }
                    do {
                        return try await self.fetchPokemonDetailWithWeaknesses(for: pokemon)
                    } catch {
                        print("Failed to fetch detail for \(pokemon.name): \(error.localizedDescription)")
                        return nil
                    }
                }
            }
            
            for await result in group {
                if let detail = result {
                    do {
                        try await dataManager.savePokemonDetail(detail)
                    } catch {
                        print("Failed to save detail for \(detail.name): ", error)
                    }
                }
            }
        }
    }
    
    /// Fetches weaknesses for a given Pokémon detail by querying each type's details.
    fileprivate func fetchWeaknesses(for detail: PokemonDetailResponse) async -> [String] {
        var weaknesses = Set<String>()
        await withTaskGroup(of: [String].self) { group in
            for pokemonType in detail.types {
                group.addTask { [weak self] in
                    guard let self = self else { return [] }
                    do {
                        let typeURL = try self.url(from: pokemonType.type.url)
                        let typeDetail = try await self.client.fetch(
                            url: typeURL,
                            as: TypeDetailResponse.self
                        )
                        return typeDetail.damageRelations.doubleDamageFrom.compactMap { $0.name }
                    } catch {
                        print("Failed to fetch weaknesses for \(pokemonType.type.name): \(error)")
                        return []
                    }
                }
            }
            for await typeWeaknesses in group {
                weaknesses.formUnion(typeWeaknesses)
            }
        }
        return Array(weaknesses)
    }
    
    /// Fetches a Pokémon's detail along with its weaknesses.
    /// Call this method after you've fetched a Pokémon's detail.
    fileprivate func fetchPokemonDetailWithWeaknesses(for pokemon: PokemonResponse) async throws -> PokemonDetailResponse {
        let detailURL = try url(from: pokemon.url)
        var detail = try await client.fetch(url: detailURL, as: PokemonDetailResponse.self)
        
        /// Fetch species details and update the detail object
        let speciesURL = try url(from: detail.species.url)
        async let speciesDetail = client.fetch(url: speciesURL, as: SpeciesDetailResponse.self)
        
        let detailSnapshot = detail
        async let weaknesses: [String] = fetchWeaknesses(for: detailSnapshot)
        
        let (speciesInfo, weaknessTypes) = try await (speciesDetail, weaknesses)
        
        let evolutionURL = try url(from: speciesInfo.evolutionChain.url)
        let evolution = try await client.fetch(url: evolutionURL, as: EvolutionResponse.self)
        let evolutionChain = extractSpeciesChain(from: evolution.chain)
        
        let evolutionDetailChain = await fetchPokemonArtworks(for: evolutionChain)
        
        detail.species.detail = speciesInfo
        detail.evolutionDetailChain = evolutionDetailChain
        detail.weaknessTypes = weaknessTypes
        return detail
    }
    
    /// Concurrently fetches Pokémon details for a list of Pokémon names and stores their official artwork URLs.
    func fetchPokemonArtworks(for evolutionChain: [(name: String, minLevel: Int?)]) async -> [ChainDetailResponse] {
        var results: [ChainDetailResponse] = []
        await withTaskGroup(of: ChainDetailResponse?.self) { group in
            for (name, lvl) in evolutionChain {
                group.addTask { [weak self] in
                    guard let self = self else { return nil }
                    do {
                        let url = try self.url(from: "https://pokeapi.co/api/v2/pokemon/\(name)/")
                        let detail = try await self.client.fetch(url: url, as: PokemonDetailResponse.self)
                        if let artwork = detail.sprites.other?.officialArtwork.frontDefault {
                            return ChainDetailResponse(id: detail.id, name: name,
                                                       minLevel: lvl ?? .zero,
                                                       artwork: artwork)
                        }
                    } catch {
                        print("Failed to fetch artwork for \(name): \(error)")
                    }
                    return nil
                }
            }
            
            for await result in group {
                if let item = result {
                    results.append(item)
                }
            }
        }
        return results
    }
    
    /// Safely converts a string into a `URL` instance.
    ///
    /// - Parameter string: A valid URL string to be converted.
    /// - Throws: `URLError(.badURL)` if the string cannot be converted to a valid `URL`.
    /// - Returns: A `URL` object initialized with the provided string.
    fileprivate func url(from string: String) throws -> URL {
        guard let url = URL(string: string) else { throw URLError(.badURL) }
        return url
    }
    
    /**
     Recursively extracts species names along with their minimum evolution levels from an evolution chain.
     - Parameter chain: The root of the evolution chain.
     - Returns: An array of tuples `(name, minLevel)` in chain order.
     */
    func extractSpeciesChain(from chain: ChainResponse) -> [(name: String, minLevel: Int?)] {
        var result: [(name: String, minLevel: Int?)] = []
        // Current species and its min evolution level (if any)
        let minLevel = chain.evolutionDetails.first?.minLevel
        result.append((name: chain.species.name, minLevel: minLevel))
        // Process each evolution branch recursively
        for child in chain.evolvesTo ?? [] {
            let childSpecies = extractSpeciesChain(from: child)
            result.append(contentsOf: childSpecies)
        }
        return result
    }
}
