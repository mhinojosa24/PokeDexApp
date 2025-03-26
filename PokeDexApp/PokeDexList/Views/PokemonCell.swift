//
//  PokemonCell.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import UIKit


class PokemonCell: UICollectionViewCell {
    static var identifier: String { String(describing: self) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
