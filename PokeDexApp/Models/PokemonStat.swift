//
//  PokemonStat.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/30/25.
//

import Foundation

/// Encapsulates each Pokémon stat’s key, display name, and min/max calculation logic.
enum PokemonStat: String, CaseIterable {
    case hp = "hp"
    case attack = "attack"
    case defense = "defense"
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed = "speed"

    /// User-facing label for the stat.
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

    /// Returns the minimum and maximum values for a given base stat.
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
