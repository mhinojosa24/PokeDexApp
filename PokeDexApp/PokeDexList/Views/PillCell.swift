//
//  PillCell.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/9/25.
//

import UIKit

class PillCell: UICollectionViewCell {
    static var identifier: String { String(describing: self) }
    
    private lazy var pillLabel: PillLabel = {
        let label = PillLabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        contentView.addSubview(pillLabel)
        pillLabel.constrain([
            .top(targetAnchor: contentView.topAnchor),
            .leading(targetAnchor: contentView.leadingAnchor),
            .trailing(targetAnchor: contentView.trailingAnchor),
            .bottom(targetAnchor: contentView.bottomAnchor),
            .height(25)
        ])
    }
    
    func configure(text: String, backgroundColor: PokemonTypeColor) {
        pillLabel.text = text
        pillLabel.backgroundColor = backgroundColor.color
    }
}
