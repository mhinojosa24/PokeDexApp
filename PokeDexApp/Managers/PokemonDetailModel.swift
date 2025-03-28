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
    var stats: [StatModel]
    var types: [PokemonTypeModel]
    var weight: Int
    
    init(id: Int, name:
         String,
         sprite: SpriteModel,
         stats: [StatModel],
         types: [PokemonTypeModel],
         weight: Int) {
        self.id = id
        self.name = name
        self.sprite = sprite
        self.stats = stats
        self.types = types
        self.weight = weight
    }
    
    func update(_ object: PokemonDetailModel) {
        self.name = object.name
        self.sprite = object.sprite
        self.stats = object.stats
        self.types = object.types
        self.weight = object.weight
    }
}

@Model
class SpriteModel {
    var officialArtwork: String
    var showdownGifURL: String
    
    init(officialArtwork: String, showdownGifURL: String) {
        self.officialArtwork = officialArtwork
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
