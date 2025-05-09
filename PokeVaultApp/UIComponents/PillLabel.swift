//
//  PillLabel.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/9/25.
//

import UIKit

/// A custom `UILabel` subclass that adds internal padding and pill-shaped styling.
///
/// `PillLabel` is useful for displaying text inside pill-shaped backgrounds,
/// often used for tags or categories in UI designs.
class PillLabel: UILabel {
    
    /// The padding applied to the text inside the label.
    var edgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
    
    /// Overrides the drawing area of the text to apply edge insets.
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    /// Adjusts the intrinsic content size of the label to account for padding.
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                      height: size.height + edgeInsets.top + edgeInsets.bottom)
    }
    
    /// Configures the label with styling parameters.
    ///
    /// - Parameters:
    ///   - text: The text to display in the label.
    ///   - textColor: The color of the text. Default is black.
    ///   - font: The font used for the text.
    ///   - textAlignment: The alignment of the text. Default is center.
    ///   - backgroundColor: A `PokemonTypeColor` that determines the label background.
    func configure(with text: String, textColor: UIColor = .black, font: UIFont, textAlignment: NSTextAlignment = .center, backgroundColor: PokemonTypeColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor.color
        self.textAlignment = textAlignment
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
