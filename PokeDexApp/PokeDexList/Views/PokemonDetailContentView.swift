//
//  PokemonDetailView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/4/25.
//

import UIKit
import SDWebImage

class PokemonDetailContentView: UIView {
    
    // MARK: - UI Model
    struct UIModel {
        let pokemonImageURLString: String      // Main Pokémon image (static)
        let backgroundImageColor: ColorType
        let name: String
        let description: String
        let types: [String]
        let weaknesses: [String]
        let evolutions: [URL]         // Evolution images as GIF URLs
    }
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pokemonImageView,
            nameLabel,
            typeStackView,
            descriptionLabel,
            weaknessTitleLabel,
            weaknessStackView,
            evolutionTitleLabel,
            evolutionStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Main Pokémon image (static)
    private lazy var pokemonImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Stack view for type pills
    private lazy var typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weaknessTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weakness"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Stack view for weakness pills
    private lazy var weaknessStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var evolutionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Evolutions"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Stack view for evolution GIFs
    private lazy var evolutionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Subviews & Constraints
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        // Constrain scrollView to the view's edges
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Constrain contentStackView inside the scrollView with padding
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        // Set fixed height for the main Pokémon image
        NSLayoutConstraint.activate([
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with model: UIModel) {
        // Load the main Pokémon image
        pokemonImageView.imageURLString = model.pokemonImageURLString
        pokemonImageView.backgroundColor = model.backgroundImageColor.color
        
        // Set the Pokémon name (uppercase for style)
        nameLabel.text = model.name.uppercased()
        
        // Set the description
        descriptionLabel.text = model.description
        
        // Populate type pills
        typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for type in model.types {
            let pill = createPillLabel(with: type.capitalized, backgroundColor: color(for: type))
            typeStackView.addArrangedSubview(pill)
        }
        
        // Populate weakness pills
        weaknessStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for weakness in model.weaknesses {
            let pill = createPillLabel(with: weakness.capitalized, backgroundColor: color(for: weakness))
            weaknessStackView.addArrangedSubview(pill)
        }
        
        // Populate evolution GIFs
        evolutionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for evolutionURL in model.evolutions {
            let evoImageView = SDAnimatedImageView()
            evoImageView.contentMode = .scaleAspectFit
            evoImageView.sd_setImage(with: evolutionURL)
            evoImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                evoImageView.widthAnchor.constraint(equalToConstant: 64),
                evoImageView.heightAnchor.constraint(equalToConstant: 64)
            ])
            evolutionStackView.addArrangedSubview(evoImageView)
        }
    }
    
    // MARK: - Helper Methods
    
    private func createPillLabel(with text: String, backgroundColor: UIColor) -> UILabel {
        let label = PaddingLabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return label
    }
    
    private func color(for category: String) -> UIColor {
        switch category.lowercased() {
        case "grass":   return .systemGreen
        case "poison":  return .systemPurple
        case "fire":    return .systemRed
        case "ice":     return .systemTeal
        case "psychic": return .systemPink
        case "flying":  return .systemBlue
        default:        return .darkGray
        }
    }
}

// Optional: A simple PaddingLabel subclass to add padding around text.
class PaddingLabel: UILabel {
    var edgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                      height: size.height + edgeInsets.top + edgeInsets.bottom)
    }
}
