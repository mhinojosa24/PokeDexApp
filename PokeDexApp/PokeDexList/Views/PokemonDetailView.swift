//
//  PokemonDetailView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/4/25.
//

import UIKit
import SDWebImage


class PokemonDetailView: UIView {
    struct UIModel {
        let pokemonGifURL: URL
        let name: String
        let description: String
        let types: [String]
        let weaknesses: [String]
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pokemonImageView, nameLabel, typeStackView, descriptionLabel, weaknessTitleLabel, weaknessStackView, evolutionTitleLabel, evolutionStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var typeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
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
    
    private lazy var evolutionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init(model: UIModel) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(pokemonImageView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(typeStackView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(weaknessTitleLabel)
        contentStackView.addArrangedSubview(weaknessStackView)
        contentStackView.addArrangedSubview(evolutionTitleLabel)
        contentStackView.addArrangedSubview(evolutionStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.constrain(to: self, edges: [
            .top(0),
            .leading(0),
            .trailing(0),
            .bottom(0)
        ])
        
        contentStackView.constrain(to: scrollView, edges: [
            .top(0),
            .leading(0),
            .trailing(0),
            .bottom(0)
        ])
        
        pokemonImageView.constrain(to: self, edges: [
            .height(200)
        ])
    }
}
