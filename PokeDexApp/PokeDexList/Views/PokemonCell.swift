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
        let colorType: ColorType
        
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
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = #colorLiteral(red: 0.2736880779, green: 0.3552958667, blue: 0.4221251607, alpha: 1)
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
        thumbnailImageView.image = UIImage(systemName: "photo.fill")
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
        stackView.constrain(to: contentView, edges: [
            .top(12),
            .leading(0),
            .trailing(0),
            .bottom(10)
        ])
        
        // Thumbnail Image View
        thumbnailImageView.constrain(to: stackView, edges: [
            .heightMultiplier(0.75),
            .widthMultiplier(0.75)
        ])
    }
    
    func configure(with model: UIModel) {
        thumbnailImageView.imageURLString = model.thumbnail
        nameLabel.text = model.name
        let formattedNumber = String(format: "#%03d", model.pokedexNumber)
        numberLabel.text = formattedNumber
        contentView.backgroundColor = model.colorType.color
    }
}
