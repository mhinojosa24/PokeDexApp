//
//  PokemonCell.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/26/25.
//

import UIKit

// MARK: - Pokemon Cell
class PokemonCell: UICollectionViewCell {
    struct UIModel: Hashable {
        let thumbnail: String
        let name: String
        let pokedexNumber: Int
        let colorType: PokemonBackgroundColor
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(pokedexNumber)
        }
        
        static func == (lhs: UIModel, rhs: UIModel) -> Bool {
            return lhs.pokedexNumber == rhs.pokedexNumber
        }
    }
    
    lazy var thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "silhouette")
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = PokemonBackgroundColor.darkNavyBlue.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = PokemonBackgroundColor.darkNavyBlue.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [thumbnailImageView, UIView(), nameLabel, numberLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    static var identifier: String { String(describing: self) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // NOTE: Cancelling the task is important to avoid image flickering when reusing cells.
        thumbnailImageView.image = UIImage(named: "silhouette")
        thumbnailImageView.currentTask?.cancel() // shout to josh for the tip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        layer.cornerRadius = 15
        layer.masksToBounds = true
        contentView.addSubview(stackView)
        stackView.addSubview(thumbnailImageView)
        // Stack View
        stackView.constrain([
            .top(targetAnchor: contentView.topAnchor, constant: 12),
            .leading(targetAnchor: contentView.leadingAnchor),
            .trailing(targetAnchor: contentView.trailingAnchor),
            .bottom(targetAnchor: contentView.bottomAnchor, constant: 10)
        ])
        
        // Thumbnail Image View
        thumbnailImageView.constrain([
            .heightMultiplier(targetAnchor: stackView.heightAnchor, multiplier: 0.75),
            .widthMultiplier(targetAnchor: stackView.widthAnchor, multiplier: 0.75)
        ])
    }
    
    func configure(with model: UIModel) {
        thumbnailImageView.imageURLString = model.thumbnail
        nameLabel.text = model.name.capitalized
        let formattedNumber = String(format: "%03d", model.pokedexNumber)
        numberLabel.text = formattedNumber
        contentView.backgroundColor = model.colorType.color.withAlphaComponent(0.45)
    }
}
