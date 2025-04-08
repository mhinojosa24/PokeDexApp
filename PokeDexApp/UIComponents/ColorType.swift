//
//  ColorType.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/29/25.
//

import UIKit

enum ColorType {
    case pokemonTheme(String)
    case pokemonTypeTheme(String)
    
    var color: UIColor {
        switch self {
        case .pokemonTheme(let colorName):
            switch colorName.lowercased() {
            case "black":
                return UIColor.black.withAlphaComponent(0.25)
            case "blue":
                return UIColor.systemBlue.withAlphaComponent(0.25)
            case "brown":
                return UIColor.systemBrown.withAlphaComponent(0.25)
            case "gray":
                return UIColor.systemGray.withAlphaComponent(0.25)
            case "green":
                return UIColor.systemGreen.withAlphaComponent(0.25)
            case "pink":
                return UIColor.systemPink.withAlphaComponent(0.25)
            case "purple":
                return UIColor.systemPurple.withAlphaComponent(0.25)
            case "red":
                return UIColor.systemRed.withAlphaComponent(0.25)
            case "white":
                return UIColor.lightGray.withAlphaComponent(0.25)
            case "yellow":
                return UIColor.systemYellow.withAlphaComponent(0.25)
            default:
                return UIColor.black.withAlphaComponent(0.25)
            }
            
        case .pokemonTypeTheme(let colorName):
            switch colorName.lowercased() {
            case "normal":
                return #colorLiteral(red: 0.7098076344, green: 0.7098010182, blue: 0.5342559814, alpha: 1).withAlphaComponent(0.65)
            case "fighting":
                return #colorLiteral(red: 0.7749266028, green: 0.1914702952, blue: 0.1603313088, alpha: 1).withAlphaComponent(0.65)
            case "flying":
                return #colorLiteral(red: 0.6947016716, green: 0.6209036708, blue: 0.9687926173, alpha: 1).withAlphaComponent(0.65)
            case "poison":
                return #colorLiteral(red: 0.6381583214, green: 0.2543672621, blue: 0.6378104687, alpha: 1).withAlphaComponent(0.65)
            case "ground":
                return #colorLiteral(red: 0.9105606079, green: 0.8121599555, blue: 0.5332868099, alpha: 1).withAlphaComponent(0.65)
            case "rock":
                return #colorLiteral(red: 0.6460644603, green: 0.5820371509, blue: 0.291392535, alpha: 1).withAlphaComponent(0.65)
            case "bug":
                return #colorLiteral(red: 0.6446012855, green: 0.6795505881, blue: 0.2920807004, alpha: 1).withAlphaComponent(0.65)
            case "ghost":
                return #colorLiteral(red: 0.4506624937, green: 0.3530937433, blue: 0.612631619, alpha: 1).withAlphaComponent(0.65)
            case "steel":
                return #colorLiteral(red: 0.7411738038, green: 0.7411785722, blue: 0.8395575881, alpha: 1).withAlphaComponent(0.65)
            case "fire":
                return #colorLiteral(red: 0.968355, green: 0.5264238119, blue: 0.2172999084, alpha: 1).withAlphaComponent(0.65)
            case "water":
                return #colorLiteral(red: 0.4384691119, green: 0.592559576, blue: 0.9682577252, alpha: 1).withAlphaComponent(0.65)
            case "grass":
                return #colorLiteral(red: 0.4770475626, green: 0.8002538085, blue: 0.3125849068, alpha: 1).withAlphaComponent(0.65)
            case "electric":
                return #colorLiteral(red: 1, green: 0.8737840056, blue: 0.3387050033, alpha: 1).withAlphaComponent(0.65)
            case "psychic":
                return #colorLiteral(red: 1, green: 0.3958920836, blue: 0.5587875247, alpha: 1).withAlphaComponent(0.65)
            case "ice":
                return #colorLiteral(red: 0.6108773351, green: 0.8697630167, blue: 0.8703106046, alpha: 1).withAlphaComponent(0.65)
            case "dragon":
                return #colorLiteral(red: 0.4491026998, green: 0.2235376537, blue: 0.9983978868, alpha: 1).withAlphaComponent(0.65)
            case "dark":
                return #colorLiteral(red: 0.4506705999, green: 0.3530851305, blue: 0.2892486751, alpha: 1).withAlphaComponent(0.65)
            case "fairy":
                return #colorLiteral(red: 0.9926783442, green: 0.7304494977, blue: 0.9120352864, alpha: 1).withAlphaComponent(0.65)
            case "stellar", "unknown":
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).withAlphaComponent(0.65)
            default:
                return UIColor.black.withAlphaComponent(0.25)
            }
        }
    }
}
