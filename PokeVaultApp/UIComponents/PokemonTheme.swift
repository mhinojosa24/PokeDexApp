//
//  ColorType.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/29/25.
//

import UIKit

// MARK: - Pokemon Background Colors

/// Represents background color themes associated with Pokémon UI elements,
/// such as card backgrounds or headers. These are mapped by string identifiers
/// and converted into corresponding `UIColor` values.
enum PVColor: String {
    case black, gray, darkNavyBlue, softBeige, icyWhite

    /// Returns the `UIColor` representation of the background color type.
    /// Defaults to `.unknown` gray color if an unknown type is provided.
    var color: UIColor {
        switch self {
        case .black:
            return .black
        case .gray:
            return #colorLiteral(red: 0.7158644795, green: 0.7258198261, blue: 0.8154850602, alpha: 1)
        case .darkNavyBlue:
            return #colorLiteral(red: 0.2980392157, green: 0.3137254902, blue: 0.5803921569, alpha: 1)
        case .softBeige:
            return #colorLiteral(red: 0.9895073771, green: 0.9597759843, blue: 0.9040811658, alpha: 1)
        case .icyWhite:
            return #colorLiteral(red: 0.9843137255, green: 0.9882352941, blue: 0.9882352941, alpha: 1)
        }
    }
}

enum PVPokemonType: String {
    case normal, fighting, flying, poison, ground, rock, bug, ghost, steel
    case fire, water, grass, electric, psychic, ice, dragon, dark, fairy, stellar, unknown
    
    init(_ type: String) {
        self = PVPokemonType(rawValue: type.lowercased()) ?? .unknown
    }
    
    /// Returns the associated icon image for the Pokémon type.
    /// Falls back to the 'normal' type icon if the specified image is not found.
    var icon: UIImage {
        return UIImage(named: self.rawValue) ?? UIImage(named: PVPokemonType.normal.rawValue)!
    }
    
    var tag: UIImage {
        return UIImage(named: self.rawValue + "Tag") ?? UIImage(named: PVPokemonType.normal.rawValue + "Tag")!
    }
    
    var color: UIColor {
        switch self {
        case .normal:
            return .init(hex: "#9B9DA1") ?? .clear
        case .fighting:
            return .init(hex: "#C84E59") ?? .clear
        case .flying:
            return .init(hex: "#A0B3E4") ?? .clear
        case .poison:
            return .init(hex: "#AA67C8") ?? .clear
        case .ground:
            return .init(hex: "#CC895E") ?? .clear
        case .rock:
            return .init(hex: "#CCC192") ?? .clear
        case .bug:
            return .init(hex: "#A4C04B") ?? .clear
        case .ghost:
            return .init(hex: "#6A70BF") ?? .clear
        case .steel:
            return .init(hex: "#6594A2") ?? .clear
        case .fire:
            return .init(hex: "#ECA95F") ?? .clear
        case .water:
            return .init(hex: "#679CDA") ?? .clear
        case .grass:
            return .init(hex: "#76BC6C") ?? .clear
        case .electric:
            return .init(hex: "#E9D65C") ?? .clear
        case .psychic:
            return .init(hex: "#E8837E") ?? .clear
        case .ice:
            return .init(hex: "#92D2C9") ?? .clear
        case .dragon:
            return .init(hex: "#3271C1") ?? .clear
        case .dark:
            return .init(hex: "#5F606C") ?? .clear
        case .fairy:
            return .init(hex: "#E29BE2") ?? .clear
        case .stellar, .unknown:
            return .clear
        }
    }
}


extension UIColor {
    /// Creates a UIColor object from a hexadecimal string.
    ///
    /// This initializer supports 6-digit (e.g., "RRGGBB") and 8-digit (e.g., "RRGGBBAA")
    /// hex strings, with or without a leading "#".
    ///
    /// - Parameter hex: The hexadecimal color string.
    /// - Returns: An initialized UIColor object, or `nil` if the string is invalid.
    ///
    /// ## Usage Example:
    /// ```
    /// let primaryColor = UIColor(hex: "#FF5733")
    /// let translucentBlue = UIColor(hex: "007BFF80") // with 50% alpha
    /// let invalidColor = UIColor(hex: "invalid") // returns nil
    /// ```
    public convenience init?(hex: String) {
        // 1. Sanitize the hex string: remove leading "#" and trim whitespace.
        var cleanString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanString.hasPrefix("#") {
            cleanString.remove(at: cleanString.startIndex)
        }

        // 2. Check if the string has a valid length (6 for RGB, 8 for RGBA).
        guard cleanString.count == 6 || cleanString.count == 8 else {
            return nil
        }

        // 3. Scan the string to convert it to a 64-bit integer.
        var rgbValue: UInt64 = 0
        Scanner(string: cleanString).scanHexInt64(&rgbValue)

        // 4. Extract the Red, Green, Blue, and Alpha components using bitwise operations.
        let red, green, blue, alpha: CGFloat
        if cleanString.count == 6 {
            // For 6-digit hex (RRGGBB)
            red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgbValue & 0x0000FF) / 255.0
            alpha = 1.0
        } else {
            // For 8-digit hex (RRGGBBAA)
            red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
        }

        // 5. Initialize the UIColor with the calculated components.
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
