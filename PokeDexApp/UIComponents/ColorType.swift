//
//  ColorType.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/29/25.
//

import UIKit

enum ColorType {
    case customColor(String)
    
    var color: UIColor {
        switch self {
        case .customColor(let colorName):
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
        }
    }
}
