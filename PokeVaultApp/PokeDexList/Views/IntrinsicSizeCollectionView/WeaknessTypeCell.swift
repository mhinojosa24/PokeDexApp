//
//  WeaknessTypeCell.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 5/7/25.
//

import UIKit


class WeaknessTypeCell: UICollectionViewCell {
    static var identifier: String { String(describing: self) }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        contentView.addSubview(imageView)
        imageView.constrain([
            .top(targetAnchor: contentView.topAnchor),
            .leading(targetAnchor: contentView.leadingAnchor),
            .trailing(targetAnchor: contentView.trailingAnchor),
            .bottom(targetAnchor: contentView.bottomAnchor),
            .height(40)
        ])
    }
    
    func configure(type: String) {
        imageView.image = PokemonType(type).icon
    }
}
