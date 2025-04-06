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
    var sprite: SpriteModel
    var themeColor: String
    var flavorDescription: String
    var stats: [StatModel]
    var weight: Int
    
    init(id: Int,
         name: String,
         sprite: SpriteModel,
         themeColor: String,
         flavorDescription: String,
         stats: [StatModel],
         weight: Int) {
        self.id = id
        self.name = name
        self.sprite = sprite
        self.themeColor = themeColor
        self.flavorDescription = flavorDescription
        self.stats = stats
        self.weight = weight
    }
    
    func update(_ object: PokemonDetailModel) {
        self.name = object.name
        self.sprite = object.sprite
        self.themeColor = object.themeColor
        self.flavorDescription = object.flavorDescription
        self.stats = object.stats
        self.weight = object.weight
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
class PokemonTypeModel {
    var name: String
    var iconURL: String
    
    init(name: String, iconURL: String) {
        self.name = name
        self.iconURL = iconURL
    }
}
