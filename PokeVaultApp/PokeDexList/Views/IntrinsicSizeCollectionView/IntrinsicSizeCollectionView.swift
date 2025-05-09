//
//  IntrinsicSizeCollectionView.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/9/25.
//

import UIKit


// MARK: - IntrinsicSizeCollectionView
class IntrinsicSizeCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
