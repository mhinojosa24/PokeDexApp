//
//  MigrationPlan.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 7/26/25.
//

import SwiftData

enum MigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1ToV2]
    }
    
    static let migrateV1ToV2 = MigrationStage.lightweight(
        fromVersion: SchemaV1.self,
        toVersion: SchemaV2.self
    )
}

enum SchemaV1: VersionedSchema {
    static let v1 = Schema.Version(1, 0, 0)
    
    static var versionIdentifier: Schema.Version { v1 }
    
    static var models: [any PersistentModel.Type] {
        [
            PokemonDetailModel.self,
            AbilityModel.self,
            SpriteModel.self,
            StatModel.self,
            TypeModel.self,
            EvolutionModel.self
        ]
    }
    
    @Model
    final class PokemonDetailModel {
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
    }
    
    @Model
    final class AbilityModel {
        var name: String
        
        init(name: String) {
            self.name = name
        }
    }

    @Model
    final class SpriteModel {
        var artwork: String
        var showdownGifURL: String
        
        init(officialArtwork: String, showdownGifURL: String) {
            self.artwork = officialArtwork
            self.showdownGifURL = showdownGifURL
        }
    }

    @Model
    final class StatModel {
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
    final class TypeModel {
        var name: String
        
        init(name: String) {
            self.name = name
        }
    }

    @Model
    final class EvolutionModel {
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
}

enum SchemaV2: VersionedSchema {
    static let v2 = Schema.Version(1, 0, 1)
    
    static var versionIdentifier: Schema.Version { v2 }
    
    static var models: [any PersistentModel.Type] {
        [
            PokemonDetailModel.self,
            AbilityModel.self,
            SpriteModel.self,
            StatModel.self,
            TypeModel.self,
            WeaknessTypeModel.self,
            EvolutionModel.self
        ]
    }
}


