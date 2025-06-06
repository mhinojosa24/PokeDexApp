//
//  PokemonDetailResponse.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/25/25.
//

// MARK: - Pokemon Detail
struct PokemonDetailResponse: Decodable {
    let id: Int // Pokemon ID
    let name: String // Name of pokemon
    let abilities: [AbilityResponse]
    let sprites: SpriteResponse // Thumbnail image
    let stats: [StatResponse] // Stats info of pokemon
    let types: [PokemonTypeResponse] // Type of pokemon
    let weight: Int // Weight of pokemon
    let height: Int // Height of pokemon
    let baseExperience: Int
    var species: SpeciesResponse // Species info
    var weaknessTypes: [String]?
    var evolutionDetailChain: [ChainDetailResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, abilities, species, sprites, stats, types
        case weight, height, weaknessTypes, evolutionDetailChain
        case baseExperience = "base_experience"
    }
}

// MARK: - Species Response
struct SpeciesResponse: Decodable {
    let name: String
    let url: String
    var detail: SpeciesDetailResponse?
}

// MARK: - Species Detail Response
struct SpeciesDetailResponse: Decodable {
    let captureRate: Int
    let growthRate: GrowthRateResponse
    let color: ColorResponse
    let evolutionChain: EvolutionChainResponse
    var flavorTextEntries: [FlavorTextResponse]?
    let genera: [GeneraDetailResponse]

    enum CodingKeys: String, CodingKey {
        case captureRate = "capture_rate"
        case growthRate = "growth_rate"
        case evolutionChain = "evolution_chain"
        case color
        case flavorTextEntries = "flavor_text_entries"
        case genera
    }
}

// MARK: - Genera Detail Response
struct GeneraDetailResponse: Decodable {
    let genus: String
    let language: LanguageResponse
}

// MARK: - Language Response
struct LanguageResponse: Decodable {
    let name: String
}

// MARK: - Growth Rate Response
struct GrowthRateResponse: Decodable {
    let name: String
}

// MARK: - Ability Response
struct AbilityResponse: Decodable {
    let ability: AbilityDetailResponse
}

// MARK: - Ability Detail Response
struct AbilityDetailResponse: Decodable {
    let name: String
}

// MARK: - Evolution Chain Response
struct EvolutionChainResponse: Decodable {
    let url: String
}

// MARK: - Evolution Response
struct EvolutionResponse: Decodable {
    let chain: ChainResponse
}

// MARK: - Chain Response
struct ChainResponse: Decodable {
    let evolutionDetails: [EvolutionDetailsResponse]
    let species: ChainSpeciesResponse
    let evolvesTo: [ChainResponse]?
    
    enum CodingKeys: String, CodingKey {
        case evolutionDetails = "evolution_details"
        case species
        case evolvesTo = "evolves_to"
    }
}

// MARK: - Evolution Details Response
struct EvolutionDetailsResponse: Decodable {
    let minLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case minLevel = "min_level"
    }
}

// MARK: - Chain Species Response
struct ChainSpeciesResponse: Decodable {
    let name: String
    let url: String
}

// MARK: - Chain Detail Response
struct ChainDetailResponse: Decodable {
    let id: Int
    let name: String
    let minLevel: Int?
    let artwork: String
}

// MARK: - Color Response
struct ColorResponse: Decodable {
    var name: String
}

// MARK: - Flavor Text Response
struct FlavorTextResponse: Decodable {
    let flavorText: String
    let version: VersionResponse
    
    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case version
    }
}

// MARK: - Version Response
struct VersionResponse: Decodable {
    let name: String
}

// MARK: - Sprite Response
struct SpriteResponse: Decodable {
    let other: OtherResponse?
}

// MARK: - Other Response
struct OtherResponse: Decodable {
    let officialArtwork: OfficialArtworkResponse
    let showdown: ShowDownResponse? // GIF url object
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
        case showdown
    }
}

// MARK: - Official Artwork Response
struct OfficialArtworkResponse: Decodable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Show Down Response
struct ShowDownResponse: Decodable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - Pokemon Type Response
struct PokemonTypeResponse: Decodable {
    var type: TypeResponse
}

// MARK: - Pokemon Type Detail Response
struct TypeResponse: Decodable {
    let name: String
    let url: String
}

// MARK: - Type Detail Response
struct TypeDetailResponse: Decodable {
    let damageRelations: DamageRelationResponse
    let sprites: SpriteTypeResponse?
    
    enum CodingKeys: String, CodingKey {
        case damageRelations = "damage_relations"
        case sprites
    }
}

// MARK: - Damage Relation Response
struct DamageRelationResponse: Decodable {
    let doubleDamageFrom: [TypeResponse]
    
    enum CodingKeys: String, CodingKey {
        case doubleDamageFrom = "double_damage_from"
    }
}

// MARK: - Type Sprite Response
struct SpriteTypeResponse: Decodable {
    let generationIII: GenerationResponse?
    
    enum CodingKeys: String, CodingKey {
        case generationIII = "generation-iii"
    }
}

// MARK: - Generation Response
struct GenerationResponse: Decodable {
    let colosseum: ColosseumResponse?
    
    enum CodingKeys: String, CodingKey {
        case colosseum = "name_icon"
    }
}

// MARK: - Colosseum Response
struct ColosseumResponse: Decodable {
    let nameIcon: String
    
    enum CodingKeys: String, CodingKey {
        case nameIcon = "name_icon"
    }
}

// MARK: - Stat Response
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

// MARK: - Stat Detail Response
struct StatDetailResponse: Decodable {
    let name: String
}
