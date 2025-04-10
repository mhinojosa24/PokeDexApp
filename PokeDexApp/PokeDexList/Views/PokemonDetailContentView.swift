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
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var parentContentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pokemonImageStackView,
            contentStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.backgroundColor = model.backgroundImageColor.color
        return view
    }()
    
    private lazy var pokemonImageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            paddingView,
            pokemonImageView,
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var pokemonImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: UIWindow().frame.height * 0.35).isActive = true
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameAndTypesStackView,
            descriptionLabel,
            weaknessTitleLabel,
            weaknessCollectionView,
            evolutionTitleLabel,
            evolutionStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var nameAndTypesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, UIView(), typeStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var weaknessTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Weakness"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var weaknessCollectionView: IntrinsicSizeCollectionView = {
        let collectionViewLayout = WrappingFlowLayout()
        let collectionView = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(PillCell.self, forCellWithReuseIdentifier: PillCell.identifier)

        return collectionView
    }()
    
    private lazy var evolutionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Evolutions"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Stack view for evolution GIFs
    private lazy var evolutionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private let model: UIModel
    
    // MARK: - Initialization
    init(model: UIModel) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Subviews & Constraints
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(parentContentStackView)
        // scrollView
        scrollView.constrain(to: self, edges: [
            .top(0),
            .leading(0),
            .trailing(0),
            .bottom(0)
        ])
        // parentContentStackView
        parentContentStackView.constrain(to: self, edges: [
            .top(.zero),
            .leading(.zero),
            .trailing(.zero),
            .bottom(.zero)
        ])
    }
    
    // MARK: - Configuration
    fileprivate func configureContentView() {
        // Load the main Pokémon image
        pokemonImageView.imageURLString = model.pokemonImageURLString
        pokemonImageView.backgroundColor = model.backgroundImageColor.color
        
        // Set the Pokémon name (uppercase for style)
        nameLabel.text = model.name.capitalized
        
        // Set the description
        descriptionLabel.text = model.description.removingNewlinesAndFormFeeds()
        
        // Populate type pills
        typePillStackViewFactory()
        
        // Populate weakness pill cells
        weaknessCollectionView.reloadData()
        
        // Populate evolution GIFs
        evolutionGIFsStackViewFactory()
    }
    
    // MARK: - Helper Methods
    fileprivate func typePillStackViewFactory() {
        typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        model.types.forEach {
            let pill = PillLabel()
            pill.configure(with: $0.capitalized, font: .systemFont(ofSize: 14, weight: .semibold), backgroundColor: ColorType.pokemonTypeTheme($0).color)
            pill.translatesAutoresizingMaskIntoConstraints = false
            pill.heightAnchor.constraint(equalToConstant: 25).isActive = true
            typeStackView.addArrangedSubview(pill)
        }
    }
    
    fileprivate func evolutionGIFsStackViewFactory() {
        evolutionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        model.evolutions.forEach {
            let evoImageView = SDAnimatedImageView()
            evoImageView.contentMode = .scaleAspectFit
            evoImageView.sd_setImage(with: $0)
            evoImageView.constrain(to: self, edges: [
                .width(64),
                .height(64)
            ])
            evolutionStackView.addArrangedSubview(evoImageView)
        }
        evolutionStackView.addArrangedSubview(UIView())
    }
}

// MARK: - UICollectionViewDataSource for Weaknesses
extension PokemonDetailContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.weaknesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PillCell.identifier, for: indexPath) as? PillCell else {
            return UICollectionViewCell()
        }
        
        let weakness = model.weaknesses[indexPath.item]
        // Assumes you have a UIColor extension or function .pokemonTypeTheme(_:) for color mapping
        cell.configure(text: weakness.capitalized, backgroundColor: .pokemonTypeTheme(weakness))
        return cell
    }
}
