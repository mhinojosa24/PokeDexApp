//
//  PokemonDetailResponse.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

// MARK: - Pokemon Detail
// TODO: rename all struct response
struct PokemonDetailResponse: Decodable {
    let id: Int // Pokemon ID
    let name: String // Name of pokemon
    var species: SpeciesResponse // Species info
    let sprites: SpriteResponse // Thumbnail image
    let stats: [StatResponse] // Stats info of pokemon
    let types: [PokemonTypeResponse] // Type of pokemon
    let weight: Int // Weight of pokemon
}

// MARK: - Species
struct SpeciesResponse: Decodable {
    let name: String
    let url: String
    var detail: SpeciesDetailResponse?
}

// MARK: - Species Detail
struct SpeciesDetailResponse: Decodable {
    let color: ColorResponse
    var flavorTextEntries: [FlavorTextResponse]?

    enum CodingKeys: String, CodingKey {
        case color
        case flavorTextEntries = "flavor_text_entries"
    }
}

// MARK: - Color
struct ColorResponse: Decodable {
    var name: String
}

struct FlavorTextResponse: Decodable {
    let flavorText: String
    let version: VersionResponse
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case version
    }
}

struct VersionResponse: Decodable {
    let name: String
}

// MARK: - Sprite
struct SpriteResponse: Decodable {
    let other: OtherResponse?
    let showdown: ShowDownResponse? // GIF url object
    
    var gifURL: String? {
            return showdown?.frontDefault
        }
}

// MARK: - Other
struct OtherResponse: Decodable {
    let officialArtwork: OfficialArtworkResponse
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtworkResponse: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - ShowDown
struct ShowDownResponse: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Pokemon Type Response
struct PokemonTypeResponse: Decodable {
    var type: TypeResponse
}

// MARK: - Pokemon Type Detail
struct TypeResponse: Decodable {
    let name: String
    let url: String // call endpoint to download icon
    var typeDetail: TypeDetailResponse?
}

struct TypeDetailResponse: Decodable {
    let damageRelations: DamageRelationResponse
    let sprites: TypeSpriteResponse
    
    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
        case sprites
    }
}

struct DamageRelationResponse: Decodable {
    let doubleDamageFrom: [TypeResponse]
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
    }
}

// MARK: - Type Sprite
struct TypeSpriteResponse: Decodable {
    let generationIII: ColosseumResponse
    
    enum CodingKeys: String, CodingKey {
        case generationIII = "generation-iii"
    }
}

// MARK: - Colosseum
struct ColosseumResponse: Decodable {
    let nameIcon: String // url string for pokemon species icon
    
    enum CodingKeys: String, CodingKey {
        case nameIcon = "name_icon"
    }
}

// MARK: - Stat
struct StatResponse: Decodable {
    let baseStat: Int
    let effort: Int
    let stat: StatDetailResponse
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

// MARK: - Stat Detail
struct StatDetailResponse: Decodable {
    let name: String
}

