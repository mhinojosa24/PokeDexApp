//
//  PokemonDetailVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import Foundation

protocol PokemonDetailVM {
    func getAboutInfoUIModel() -> AboutInfoView.UIModel
    func getStatsInfoUIModel() -> [StatsInfoView.UIModel]
//    func getEvolutionUIModel() -> [String]
}
    

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
                                     abilities: pokemonDetails.abilities,
                                     catchRate: pokemonDetails.catchRate,
                                     baseExperience: pokemonDetails.baseExperience,
                                     growthRateDescription: pokemonDetails.growthRate,
                                     weaknesses: pokemonDetails.weaknesses.compactMap { $0.name })
    }

    func getStatsInfoUIModel() -> [StatsInfoView.UIModel] {
        // Create a lookup for base stat values by key
        let statDict = Dictionary(uniqueKeysWithValues: pokemonDetails.stats.map { ($0.name, $0.baseStat) })
        
        // Map each PokemonStat to a UIModel if available
        return PokemonStat.allCases.compactMap { type in
            guard let baseValue = statDict[type.rawValue] else { return .init(name: "", baseValue: .zero, minValue: .zero, maxValue: .zero) }
            let (minVal, maxVal) = type.calculateMinMax(base: baseValue)
            return StatsInfoView.UIModel(
                name: type.displayName,
                baseValue: baseValue,
                minValue: minVal,
                maxValue: maxVal
            )
        }
    }
}
