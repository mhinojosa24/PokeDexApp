//
//  PDLabel.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/12/25.
//

import UIKit

/// An enum that represents different Poppins font weights.
/// Ensure that these font names match the actual names in your project.
enum PoppinsFontWeight: String {
    case light = "Poppins-Light"
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}

/// A custom UILabel subclass that uses the Poppins font and allows customization.
class PDLabel: UILabel {
    
    /// Custom initializer.
    /// - Parameters:
    ///   - text: The text to display.
    ///   - textColor: The color of the text.
    ///   - fontWeight: The desired weight of the Poppins font.
    ///   - fontSize: The size of the font.
    ///   - backgroundColor: The background color for the label.
    init(text: String? = nil,
         textColor: PokemonBackgroundColor = .black,
         fontWeight: PoppinsFontWeight = .regular,
         fontSize: CGFloat = 17,
         backgroundColor: UIColor = .clear) {
        super.init(frame: .zero)
        self.text = text
        self.textColor = textColor.color
        self.backgroundColor = backgroundColor
        
        // Set the custom Poppins font. If unavailable, fallback to system font.
        setPoppinsFont(weight: fontWeight, size: fontSize)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Provide default customization.
        setPoppinsFont(weight: .regular, size: 17)
    }
    
    /// Sets the label's font to the specified Poppins weight and size.
    /// - Parameters:
    ///   - weight: The font weight (e.g., Regular, Bold, SemiBold).
    ///   - size: The font size.
    func setPoppinsFont(weight: PoppinsFontWeight, size: CGFloat) {
        if let customFont = UIFont(name: weight.rawValue, size: size) {
            self.font = customFont
        } else {
            // Fall back to system font if Poppins font is not found.
            self.font = UIFont.systemFont(ofSize: size)
            print("Warning: \(weight.rawValue) font not found; using system font instead.")
        }
    }
}
