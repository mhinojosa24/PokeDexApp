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
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
        contentView.backgroundColor = #colorLiteral(red: 0.9206994176, green: 0.7358378768, blue: 0.7089307904, alpha: 1)
        setupLayouts()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // NOTE: Cancelling the task is important to avoid image flickering when reusing cells.
        thumbnailImageView.image = nil
        thumbnailImageView.currentTask?.cancel() // shout to josh for the tip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayouts() {
        contentView.addSubview(stackView)
        layer.cornerRadius = 15
        layer.masksToBounds = true
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            thumbnailImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.65),
            thumbnailImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.65)
        ])
    }
    
    func configure(with model: UIModel) {
        thumbnailImageView.imageURLString = model.thumbnail
        nameLabel.text = model.name
        numberLabel.text = model.pokedexNumber.description
    }
}
