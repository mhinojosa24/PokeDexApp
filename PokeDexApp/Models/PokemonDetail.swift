//
//  PokemonDetail.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

// MARK: - Pokemon Detail
// TODO: rename all struct response
struct PokemonDetail: Decodable {
    let id: Int // Pokemon ID
    let name: String // Name of pokemon
    let sprites: Sprite // Thumbnail image
    let stats: [Stat] // Stats info of pokemon
    let types: [PokemonType] // Type of pokemon
    let weight: Int // Weight of pokemon
}

// MARK: - Sprite
struct Sprite: Decodable {
    let other: Other?
    let showdown: ShowDown? // GIF url object
}

// MARK: - Other
struct Other: Decodable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - ShowDown
struct ShowDown: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Pokemon Type
struct PokemonType: Decodable {
    let type: TypeDetail
}

// MARK: - Pokemon Type Detail
struct TypeDetail: Decodable {
    let name: String
    let url: String // call endpoint to download icon
}

// MARK: - Type Sprite
struct TypeSprite: Decodable {
    let generationIII: Colosseum
    
    enum CodingKeys: String, CodingKey {
        case generationIII = "generation-iii"
    }
}

// MARK: - Colosseum
struct Colosseum: Decodable {
    let nameIcon: String // url string for pokemon species icon
    
    enum CodingKeys: String, CodingKey {
        case nameIcon = "name_icon"
    }
}

// MARK: - Stat
struct Stat: Decodable {
    let baseStat: Int
    let effort: Int
    let stat: StatDetail
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

// MARK: - Stat Detail
struct StatDetail: Decodable {
    let name: String
}

