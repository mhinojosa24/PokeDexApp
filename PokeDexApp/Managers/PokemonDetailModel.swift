//
//  PokemonDetailModel.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import SwiftData

@Model
class PokemonDetailModel {
    @Attribute(.unique) var id: Int
    var name: String
    var abilities: [AbilityModel]
    var species: String
    var sprite: SpriteModel
    var themeColor: String
    var flavorDescription: String
    var stats: [StatModel]
    var types: [TypeModel]
    var weaknesses: [TypeModel]
    var evolution: [EvolutionModel]
    var height: Int
    var weight: Int
    var catchRate: Int
    var baseExperience: Int
    var growthRate: String
    
    init(id: Int,
         name: String,
         abilities: [AbilityModel],
         species: String,
         sprite: SpriteModel,
         themeColor: String,
         flavorDescription: String,
         stats: [StatModel],
         types: [TypeModel],
         weaknesses: [TypeModel],
         evolution: [EvolutionModel],
         height: Int,
         weight: Int,
         catchRate: Int,
         baseExperience: Int,
         growthRate: String) {
        self.id = id
        self.name = name
        self.abilities = abilities
        self.species = species
        self.sprite = sprite
        self.themeColor = themeColor
        self.flavorDescription = flavorDescription
        self.stats = stats
        self.types = types
        self.weaknesses = weaknesses
        self.evolution = evolution
        self.height = height
        self.weight = weight
        self.catchRate = catchRate
        self.baseExperience = baseExperience
        self.growthRate = growthRate
    }
    
    func update(_ object: PokemonDetailModel) {
        self.name = object.name
        self.abilities = object.abilities
        self.species = object.species
        self.sprite = object.sprite
        self.themeColor = object.themeColor
        self.flavorDescription = object.flavorDescription
        self.stats = object.stats
        self.types = object.types
        self.weaknesses = object.weaknesses
        self.evolution = object.evolution
        self.height = object.weight
        self.weight = object.weight
        self.catchRate = object.catchRate
        self.baseExperience = object.baseExperience
        self.growthRate = object.growthRate
    }
}

@Model
class AbilityModel {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

@Model
class SpriteModel {
    var artwork: String
    var showdownGifURL: String
    
    init(officialArtwork: String, showdownGifURL: String) {
        self.artwork = officialArtwork
        self.showdownGifURL = showdownGifURL
    }
}

@Model
class StatModel {
    var name: String
    var baseStat: Int
    var effort: Int
    
    init(name: String, baseStat: Int, effort: Int) {
        self.name = name
        self.baseStat = baseStat
        self.effort = effort
    }
}

@Model
class TypeModel {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

@Model
class EvolutionModel {
    var id: Int
    var name: String
    var level: Int
    var artwork: String
    
    init(id: Int, name: String, level: Int, artwork: String) {
        self.id = id
        self.name = name
        self.level = level
        self.artwork = artwork
    }
}
