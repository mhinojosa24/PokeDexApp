//
//  PokeDexDetailView.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 6/26/25.
//

import UIKit

final class PokeDexDetailView: UIView {
    // MARK: - Subviews
    
    /// Scrollable container for all child views
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    /// Rounded container holding the content stack view
    lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    /// Main Pokémon image
    lazy var thumbnail: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    /// Vertical stack containing About, Stats, and Evolution info views
    lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.backgroundColor = .clear
        return stack
    }()
    
    // MARK: - Segment View
    
    /// Label for About section (default selected)
    lazy var aboutLabel: PDLabel = {
        let label = PDLabel(text: "About", textColor: .darkNavyBlue, fontWeight: .semiBold, fontSize: 16, backgroundColor: .clear)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// Label for Stats section
    lazy var statsLabel: PDLabel = {
        let label = PDLabel(text: "Stats", fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// Label for Evolution section
    lazy var evolutionLabel: PDLabel = {
        let label = PDLabel(text: "Evolution", fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// Horizontal stack for switching between About, Stats, and Evolution views
    lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [aboutLabel, statsLabel, evolutionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.subviews.enumerated().forEach({ index, view in
            view.tag = index
            view.isUserInteractionEnabled = true
        })
        return stackView
    }()
    
    // MARK: - About View
    
    lazy var aboutInfoView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Stats View
    
    lazy var statsInfoView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Evolution View
    
    lazy var evolutionInfoView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Setup Methods
    
    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(thumbnail)
        scrollView.addSubview(segmentStackView)
        scrollView.addSubview(modalView)
        modalView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        scrollView.constrain([
            .top(targetAnchor: topAnchor),
            .leading(targetAnchor: leadingAnchor),
            .trailing(targetAnchor: trailingAnchor),
            .bottom(targetAnchor: bottomAnchor)
        ])
        
        thumbnail.constrain([
            .top(targetAnchor: scrollView.topAnchor, constant: 0),
            .centerX(targetAnchor: scrollView.centerXAnchor),
            .heightMultiplier(targetAnchor: heightAnchor, multiplier: 0.20)
        ])
        
        segmentStackView.constrain([
            .top(targetAnchor: thumbnail.bottomAnchor),
            .leading(targetAnchor: scrollView.safeAreaLayoutGuide.leadingAnchor),
            .trailing(targetAnchor: scrollView.safeAreaLayoutGuide.trailingAnchor),
            .height(50)
        ])
        
        modalView.constrain([
            .top(targetAnchor: segmentStackView.bottomAnchor),
            .leading(targetAnchor: segmentStackView.leadingAnchor),
            .trailing(targetAnchor: segmentStackView.trailingAnchor),
            .bottom(targetAnchor: bottomAnchor)
        ])
        
        contentStackView.constrain([
            .top(targetAnchor: modalView.topAnchor, constant: 24),
            .leading(targetAnchor: modalView.leadingAnchor, constant: 24),
            .trailing(targetAnchor: modalView.trailingAnchor, constant: 24),
            .bottom(targetAnchor: scrollView.bottomAnchor)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with pokemonDetails: PokemonDetailModel) {
        backgroundColor = PVPokemonType(rawValue: pokemonDetails.types.first?.name ?? "")?.color
        scrollView.backgroundColor = backgroundColor
        scrollView.layer.masksToBounds = false
        scrollView.layer.shadowColor = PVColor(rawValue: pokemonDetails.themeColor)?.color.withAlphaComponent(0.85).cgColor
        scrollView.layer.shadowOffset = .zero
        scrollView.layer.shadowRadius = 8
        scrollView.layer.shadowOpacity = 1
        
        aboutLabel.textColor = .white
        thumbnail.imageURLString = pokemonDetails.sprite.artwork
    }
    
    func injectInfoViews(about: UIStackView, stats: UIStackView, evolution: UIStackView) {
        about.tag = 0
        stats.tag = 1
        evolution.tag = 2
        
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStackView.addArrangedSubviews([about, stats, evolution])
        
        stats.isHidden = true
        evolution.isHidden = true
        
        aboutInfoView = about
        statsInfoView = stats
        evolutionInfoView = evolution
    }
    
    func selectSegment(at selectedIndex: Int) {
        for case let itemLabel as PDLabel in segmentStackView.subviews {
            let isSelected = itemLabel.tag == selectedIndex
            itemLabel.textColor = isSelected ? .white : .lightGray
            itemLabel.setPoppinsFont(weight: isSelected ? .semiBold : .medium, size: 16)
        }
        aboutInfoView.isHidden = aboutInfoView.tag != selectedIndex
        statsInfoView.isHidden = statsInfoView.tag != selectedIndex
        evolutionInfoView.isHidden = evolutionInfoView.tag != selectedIndex
    }
}
