//
//  PokemonDetailMapper.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 6/28/25.
//

import Foundation
import SwiftData

/// `PokemonDetailMapper` is responsible for mapping `PokemonDetailResponse` objects to `PokemonDetailModel` objects.
struct PokemonDetailMapper {
    /// Maps a `PokemonDetailResponse` object to a `PokemonDetailModel` object.
    /// - Parameter pokemonDetailResponse: The `PokemonDetailResponse` object to map.
    /// - Returns: The mapped `PokemonDetailModel` object.
    static func map(_ pokemonDetailResponse: PokemonDetailResponse) -> PokemonDetailModel {
        let abilities = pokemonDetailResponse.abilities.map({ AbilityModel(name: $0.ability.name) })
        let species = pokemonDetailResponse.species.detail?.genera.first(where: { $0.language.name == "en" })?.genus ?? ""
        let officialArtwork = pokemonDetailResponse.sprites.other?.officialArtwork.frontDefault ?? ""
        let showdownGifURL = pokemonDetailResponse.sprites.other?.showdown?.frontDefault ?? ""
        let sprite = SpriteModel(officialArtwork: officialArtwork, showdownGifURL: showdownGifURL)
        let themeColor = pokemonDetailResponse.species.detail?.color.name ?? ""
        let flavorDescription = pokemonDetailResponse.species.detail?.flavorTextEntries?.first(where: { $0.version.name == "ruby" })?.flavorText ?? ""
        let stats = pokemonDetailResponse.stats.map { StatModel(name: $0.stat.name, baseStat: $0.baseStat, effort: $0.effort) }
        let types = pokemonDetailResponse.types.compactMap { TypeModel(slot: $0.slot, name: $0.type.name) }
        let weaknesses = pokemonDetailResponse.weaknessTypes?.compactMap { WeaknessTypeModel(name: $0) } ?? []
        let evolution = pokemonDetailResponse.evolutionDetailChain?.compactMap { EvolutionModel(id: $0.id, name: $0.name, level: $0.minLevel ?? .zero, artwork: $0.artwork) } ?? []
        let catchRate = pokemonDetailResponse.species.detail?.captureRate ?? 0
        let growthRate = pokemonDetailResponse.species.detail?.growthRate.name ?? ""
        
        return PokemonDetailModel(id: pokemonDetailResponse.id,
                                  name: pokemonDetailResponse.name,
                                  abilities: abilities,
                                  species: species,
                                  sprite: sprite,
                                  themeColor: themeColor,
                                  flavorDescription: flavorDescription,
                                  stats: stats,
                                  types: types,
                                  weaknesses: weaknesses,
                                  evolution: evolution,
                                  height: pokemonDetailResponse.height,
                                  weight: pokemonDetailResponse.weight,
                                  catchRate: catchRate,
                                  baseExperience: pokemonDetailResponse.baseExperience,
                                  growthRate: growthRate)
    }
}
