//
//  PokemonStat.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/30/25.
//

import Foundation

/// Represents the six core Pokémon stats, each associated with a display name
/// and a method to calculate its minimum and maximum possible values at level 100.
///
/// This enum supports stat-specific logic by abstracting min/max calculations
/// based on base stats, IVs, EVs, nature modifiers, and item bonuses.
enum PokemonStat: String, CaseIterable {
    /// Hit Points (HP) stat.
    case hp = "hp"
    /// Physical Attack stat.
    case attack = "attack"
    /// Physical Defense stat.
    case defense = "defense"
    /// Special Attack stat.
    case specialAttack = "special-attack"
    /// Special Defense stat.
    case specialDefense = "special-defense"
    /// Speed stat.
    case speed = "speed"

    /// Returns a human-readable display name for each stat.
    var displayName: String {
        switch self {
        case .hp: return "HP"
        case .attack: return "Attack"
        case .defense: return "Defense"
        case .specialAttack: return "Sp. Atk"
        case .specialDefense: return "Sp. Def"
        case .speed: return "Speed"
        }
    }

    /// Calculates the minimum and maximum possible value for the given base stat.
    ///
    /// - Parameter base: The base stat value from the API.
    /// - Returns: A tuple containing the min and max stat at level 100.
    func calculateMinMax(base: Int) -> (min: Int, max: Int) {
        switch self {
        case .hp:
            // HP uses its own formula
            return hpMinMax(base: base)
        case .attack:
            return attackMinMax(base: base)
        case .defense:
            return defenseMinMax(base: base)
        case .specialAttack:
            return specialAttackMinMax(base: base)
        case .specialDefense:
            return specialDefenseMinMax(base: base)
        case .speed:
            return speedMinMax(base: base)
        }
    }

    // MARK: - Individual Stat Helpers

    /// Calculates min/max HP using base stat, IVs, EVs, and level 100.
    private func hpMinMax(base: Int, level: Int = 100) -> (min: Int, max: Int) {
        func baseCalc(iv: Int, ev: Int) -> Int {
            let evComponent = ev / 4
            return ((2 * base + iv + evComponent) * level) / 100 + level + 10
        }
        return (
            min: baseCalc(iv: 0, ev: 0),
            max: baseCalc(iv: 31, ev: 252)
        )
    }

    /// Calculates min/max Attack with IV/EV range and nature modifiers.
    private func attackMinMax(base: Int, level: Int = 100) -> (min: Int, max: Int) {
        func baseCalc(iv: Int, ev: Int) -> Int {
            let evComponent = ev / 4
            return ((2 * base + iv + evComponent) * level) / 100 + 5
        }
        let rawMin = baseCalc(iv: 0, ev: 0)
        let rawMax = baseCalc(iv: 31, ev: 252)
        return (
            min: Int(floor(Double(rawMin) * 0.9)),
            max: Int(floor(Double(rawMax) * 1.1))
        )
    }

    /// Calculates min/max Defense with IV/EV range and nature modifiers.
    private func defenseMinMax(base: Int, level: Int = 100) -> (min: Int, max: Int) {
        func baseCalc(iv: Int, ev: Int) -> Int {
            let evComponent = ev / 4
            return ((2 * base + iv + evComponent) * level) / 100 + 5
        }
        let rawMin = baseCalc(iv: 0, ev: 0)
        let rawMax = baseCalc(iv: 31, ev: 252)
        return (
            min: Int(floor(Double(rawMin) * 0.9)),
            max: Int(floor(Double(rawMax) * 1.1))
        )
    }

    /// Calculates min/max Special Attack with nature modifiers.
    private func specialAttackMinMax(base: Int, level: Int = 100) -> (min: Int, max: Int) {
        func baseCalc(iv: Int, ev: Int) -> Int {
            let evComponent = ev / 4
            return (2 * base + iv + evComponent) + 5
        }
        let rawMin = baseCalc(iv: 0,  ev: 0)
        let rawMax = baseCalc(iv: 31, ev: 252)
        return (
            min: Int(floor(Double(rawMin) * 0.9)),
            max: Int(floor(Double(rawMax) * 1.1))
        )
    }

    /// Calculates min/max Special Defense considering nature and item bonuses.
    private func specialDefenseMinMax(
        base: Int,
        iv: Int = 31,
        ev: Int = 252,
        natureDown: Double = 0.9,
        natureUp: Double = 1.1,
        itemBonus: Int = 0
    ) -> (min: Int, max: Int) {
        let baseRaw = 2 * base + 5
        let minValue = Int(floor(Double(baseRaw) * natureDown))
        let evContribution = ev / 4
        let rawTotal = baseRaw + iv + evContribution
        let boosted = floor(Double(rawTotal) * natureUp)
        return (min: minValue, max: Int(boosted) + itemBonus)
    }

    /// Calculates min/max Speed with nature modifiers at level 100.
    private func speedMinMax(
        base: Int,
        iv: Int = 31,
        ev: Int = 252,
        natureDown: Double = 0.9,
        natureUp: Double = 1.1
    ) -> (min: Int, max: Int) {
        let baseRaw = 2 * base + 5
        let minValue = Int(floor(Double(baseRaw) * natureDown))
        let evPortion = ev / 4
        let rawTotal = baseRaw + iv + evPortion
        return (
            min: minValue,
            max: Int(floor(Double(rawTotal) * natureUp))
        )
    }
}
