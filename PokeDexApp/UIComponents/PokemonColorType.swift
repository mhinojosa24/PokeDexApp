//
//  ColorType.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/29/25.
//

import UIKit

// MARK: - Pokemon Background Colors

enum PokemonBackgroundColor: String {
    case black, darkNavyBlue, blue, brown, gray, green, pink, purple, red, white, yellow, unknown
    
    init(_ type: String) {
        self = PokemonBackgroundColor(rawValue: type.lowercased()) ?? .unknown
    }

    var color: UIColor {
        switch self {
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .darkNavyBlue:
            return #colorLiteral(red: 0.297126472, green: 0.3140752614, blue: 0.5818428397, alpha: 1)
        case .blue:
            return #colorLiteral(red: 0.3905215859, green: 0.5775662065, blue: 0.9194149375, alpha: 1)
        case .brown:
            return #colorLiteral(red: 0.5743098855, green: 0.3714034557, blue: 0.1913413107, alpha: 1)
        case .gray:
            return #colorLiteral(red: 0.7158644795, green: 0.7258198261, blue: 0.8154850602, alpha: 1)
        case .green:
            return #colorLiteral(red: 0.4553773403, green: 0.7966255546, blue: 0.280756712, alpha: 1)
        case .pink:
            return #colorLiteral(red: 0.9829356074, green: 0.3329133987, blue: 0.5193170905, alpha: 1)
        case .purple:
            return #colorLiteral(red: 0.4401388168, green: 0.3330246806, blue: 0.6093851924, alpha: 1)
        case .red:
            return #colorLiteral(red: 1, green: 0.4556620121, blue: 0, alpha: 1)
        case .white:
            return #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        case .yellow:
            return #colorLiteral(red: 0.9750881791, green: 0.813549459, blue: 0.189127773, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).withAlphaComponent(0.65)
        }
    }
    
    func oxidized(_ alpha: CGFloat = 0.35) -> UIColor {
        return self.color.withAlphaComponent(alpha)
    }
}

// MARK: - Pokemon Type Colors

enum PokemonTypeColor: String {
    case normal, fighting, flying, poison, ground, rock, bug, ghost, steel
    case fire, water, grass, electric, psychic, ice, dragon, dark, fairy, stellar, unknown
    
    // Custom initializer that provides a default value if conversion fails
    init(_ type: String) {
        self = PokemonTypeColor(rawValue: type.lowercased()) ?? .unknown
    }

    var color: UIColor {
        switch self {
        case .normal:
            return #colorLiteral(red: 0.7098076344, green: 0.7098010182, blue: 0.5342559814, alpha: 1)
        case .fighting:
            return #colorLiteral(red: 0.7749266028, green: 0.1914702952, blue: 0.1603313088, alpha: 1)
        case .flying:
            return #colorLiteral(red: 0.6947016716, green: 0.6209036708, blue: 0.9687926173, alpha: 1)
        case .poison:
            return #colorLiteral(red: 0.6381583214, green: 0.2543672621, blue: 0.6378104687, alpha: 1)
        case .ground:
            return #colorLiteral(red: 0.9105606079, green: 0.8121599555, blue: 0.5332868099, alpha: 1)
        case .rock:
            return #colorLiteral(red: 0.6460644603, green: 0.5820371509, blue: 0.291392535, alpha: 1)
        case .bug:
            return #colorLiteral(red: 0.6544884443, green: 0.7196848392, blue: 0.135922581, alpha: 1)
        case .ghost:
            return #colorLiteral(red: 0.4506624937, green: 0.3530937433, blue: 0.612631619, alpha: 1)
        case .steel:
            return #colorLiteral(red: 0.7411738038, green: 0.7411785722, blue: 0.8395575881, alpha: 1)
        case .fire:
            return #colorLiteral(red: 0.968355, green: 0.5264238119, blue: 0.2172999084, alpha: 1)
        case .water:
            return #colorLiteral(red: 0.4384691119, green: 0.592559576, blue: 0.9682577252, alpha: 1)
        case .grass:
            return #colorLiteral(red: 0.4770475626, green: 0.8002538085, blue: 0.3125849068, alpha: 1)
        case .electric:
            return #colorLiteral(red: 1, green: 0.8737840056, blue: 0.3387050033, alpha: 1)
        case .psychic:
            return #colorLiteral(red: 1, green: 0.3958920836, blue: 0.5587875247, alpha: 1)
        case .ice:
            return #colorLiteral(red: 0.6108773351, green: 0.8697630167, blue: 0.8703106046, alpha: 1)
        case .dragon:
            return #colorLiteral(red: 0.4491026998, green: 0.2235376537, blue: 0.9983978868, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.4506705999, green: 0.3530851305, blue: 0.2892486751, alpha: 1)
        case .fairy:
            return #colorLiteral(red: 0.9926783442, green: 0.7304494977, blue: 0.9120352864, alpha: 1)
        case .stellar, .unknown:
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    func oxidized(_ alpha: CGFloat = 0.35) -> UIColor {
        return self.color.withAlphaComponent(alpha)
    }
}

enum PokemonType: String {
    case normal, fighting, flying, poison, ground, rock, bug, ghost, steel
    case fire, water, grass, electric, psychic, ice, dragon, dark, fairy, stellar, unknown
    
    init(_ type: String) {
        self = PokemonType(rawValue: type.lowercased()) ?? .unknown
    }
    
    /// Returns the corresponding icon image for this Pokémon type.
    /// Assumes asset catalog images are named by the type's rawValue.
    var icon: UIImage {
        // Attempt to load an image matching the type name; fallback to 'normal' if missing
        return UIImage(named: self.rawValue) ?? UIImage(named: PokemonType.normal.rawValue)!
    }
}
