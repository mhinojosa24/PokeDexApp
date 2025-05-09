//
//  PokemonDetailVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import Foundation

protocol PokemonDetailVM {
    func getAboutInfoUIModel() -> AboutInfoView.UIModel
    func getStatsInfoUIModel() -> StatsInfoView.UIModel
    func getEvolutionInfoUIModel() -> EvolutionInfoView.UIModel
}
    
/// A view model responsible for transforming Pokémon detail data into UI-ready models
/// for display in the `PokeDexDetailVC`. It prepares information for the About,
/// Stats, and Evolution sections using preloaded detail responses.
///
/// This view model encapsulates logic for:
/// - Building formatted strings for the About view (e.g., height, weight)
/// - Calculating stat ranges for the Stats view
/// - Mapping evolution chain responses to displayable stages
final class PokeDexDetailVM: PokemonDetailVM {
    
    var pokemonDetails: PokemonDetailModel
    
    init(_ pokemonDetails: PokemonDetailModel) {
        self.pokemonDetails = pokemonDetails
    }
    
    func getAboutInfoUIModel() -> AboutInfoView.UIModel {
        return AboutInfoView.UIModel(description: pokemonDetails.flavorDescription.lowercasedThenCapitalizedSentences().removingNewlinesAndFormFeeds(),
                                     themeColor: pokemonDetails.themeColor,
                                     species: pokemonDetails.species,
                                     height: .init(describing: pokemonDetails.height),
                                     weight: .init(describing: pokemonDetails.weight),
                                     abilities: pokemonDetails.abilities.map({ $0.name }),
                                     catchRate: pokemonDetails.catchRate,
                                     baseExperience: pokemonDetails.baseExperience,
                                     growthRateDescription: pokemonDetails.growthRate,
                                     weaknesses: pokemonDetails.weaknesses.compactMap { $0.name })
    }

    func getStatsInfoUIModel() -> StatsInfoView.UIModel {
        // Create a lookup for base stat values by key
        let statDict = Dictionary(uniqueKeysWithValues: pokemonDetails.stats.map { ($0.name, $0.baseStat) })
        
        // Map each PokemonStat to a UIModel if available
        let pokemonStats = PokemonStat.allCases.compactMap { type in
            guard let baseValue = statDict[type.rawValue] else { return StatsInfoView.UIModel.Stat(name: "", baseValue: .zero, minValue: .zero, maxValue: .zero) }
            let (minVal, maxVal) = type.calculateMinMax(base: baseValue)
            return StatsInfoView.UIModel.Stat(
                name: type.displayName,
                baseValue: baseValue,
                minValue: minVal,
                maxValue: maxVal
            )
        }
        return StatsInfoView.UIModel(themeColor: pokemonDetails.themeColor, stats: pokemonStats)
    }
    
    func getEvolutionInfoUIModel() -> EvolutionInfoView.UIModel {
        let evolution = pokemonDetails.evolution
        return .init(themeColor: pokemonDetails.themeColor, evolutions: evolution.compactMap({ .init(pokedexNumber: $0.id, name: $0.name, thumbnail: $0.artwork, level: $0.level) }))
    }
}
