//
//  PillLabel.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/9/25.
//

import UIKit


class PillLabel: UILabel {
    var edgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                      height: size.height + edgeInsets.top + edgeInsets.bottom)
    }
    
    func configure(with text: String, textColor: UIColor = .black, font: UIFont, textAlignment: NSTextAlignment = .center, backgroundColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.textAlignment = textAlignment
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
