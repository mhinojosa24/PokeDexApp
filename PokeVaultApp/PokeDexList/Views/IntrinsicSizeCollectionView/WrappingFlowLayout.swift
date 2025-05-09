//
//  WrappingFlowLayout.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/9/25.
//

import UIKit


class WrappingFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .vertical
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // Enable dynamic cell sizing
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
