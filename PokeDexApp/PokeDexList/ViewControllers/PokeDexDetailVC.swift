//
//  PokeDexDetailVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/11/25.
//

import UIKit


class PokeDexDetailVC: UIViewController {
    struct Constants {
        static fileprivate let headerHeight: CGFloat = 210
    }
    // MARK: - Subviews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var imageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.imageURLString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 20
        stack.backgroundColor = .clear
        return stack
    }()
    
    // MARK: - Segment View
    
    private lazy var segmentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [aboutLabel, statsLabel, evolutionLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["About", "Stats", "Evolution"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private lazy var aboutLabel: PDLabel = {
        let label = PDLabel(text: "About", textColor: .white, fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var statsLabel: PDLabel = {
        let label = PDLabel(text: "Stats", textColor: .gray, fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var evolutionLabel: PDLabel = {
        let label = PDLabel(text: "Evolution", textColor: .gray, fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - About View
    
    private lazy var aboutStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        return stack
    }()
    
    private lazy var pokemonDescriptionLabel: PDLabel = {
        let label = PDLabel(text: "", textColor: .black, fontWeight: .light, fontSize: 14, backgroundColor: .clear)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var pokemonDataLabel: PDLabel = {
        let label = PDLabel(text: "PokéDex Data", textColor: PokemonBackgroundColor(viewModel.pokemonDetails.themeColor), fontWeight: .semiBold, fontSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var trainingLabel: PDLabel = {
        let label = PDLabel(text: "Training", textColor: PokemonBackgroundColor(viewModel.pokemonDetails.themeColor), fontWeight: .semiBold, fontSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var typeWeaknessesLabel: PDLabel = {
        let label = PDLabel(text: "Type Weaknesses", textColor: PokemonBackgroundColor(viewModel.pokemonDetails.themeColor), fontWeight: .semiBold, fontSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Stats View
    
    private lazy var statsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Evolution View
    
    private lazy var evolutionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Variables & Attributes
    
    private let viewModel: PokeDexDetailVM
    
    weak var delegate: PokeDexDetailDelegate?
    
    init(viewModel: PokeDexDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupNavigationBar()
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupNavigationBar() {
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        navigationItem.largeTitleDisplayMode = .never
        configureNavigationBar(
            style: .transparent,
            tint: PokemonBackgroundColor.darkNavyBlue.color,
            hidesSeparator: true,
            prefersLargeTitles: false
        )
        
        let leftBarButtonItemAction: Selector = #selector(didTapBackButton)
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                style: .plain,
                                                target: self,
                                                action: leftBarButtonItemAction)
        leftBarButtonItem.tintColor = PokemonBackgroundColor.darkNavyBlue.color
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(segmentStackView)
        scrollView.backgroundColor = PokemonBackgroundColor(rawValue: viewModel.pokemonDetails.themeColor)?.color.withAlphaComponent(0.45)
        
        let aboutContent = configureAbout()
        let trainingContent = configureTraining()
        let weaknessContent = configureWeaknesses()
        aboutStackView.addArrangedSubview(aboutContent)
        aboutStackView.addArrangedSubview(trainingContent)
        aboutStackView.addArrangedSubview(weaknessContent)
        pokemonDescriptionLabel.text = viewModel.pokemonDetails.flavorDescription.lowercasedThenCapitalizedSentences().removingNewlinesAndFormFeeds()
        contentStackView.addArrangedSubview(pokemonDescriptionLabel)
        contentStackView.addArrangedSubview(aboutStackView)
        
        containerView.addSubview(contentStackView)
        scrollView.addSubview(containerView)
        
        scrollView.constrain([
            .top(targetAnchor: view.topAnchor),
            .leading(targetAnchor: view.leadingAnchor),
            .trailing(targetAnchor: view.trailingAnchor),
            .bottom(targetAnchor: view.bottomAnchor)
        ])
        
        imageView.constrain([
            .top(targetAnchor: scrollView.topAnchor, constant: 0),
            .centerX(targetAnchor: scrollView.centerXAnchor),
            .heightMultiplier(targetAnchor: view.heightAnchor, multiplier: 0.20)
        ])
        
        segmentStackView.constrain([
            .top(targetAnchor: imageView.bottomAnchor),
            .leading(targetAnchor: scrollView.safeAreaLayoutGuide.leadingAnchor),
            .trailing(targetAnchor: scrollView.safeAreaLayoutGuide.trailingAnchor),
            .height(50)
        ])
        
        containerView.constrain([
            .top(targetAnchor: segmentStackView.bottomAnchor),
            .leading(targetAnchor: segmentStackView.leadingAnchor),
            .trailing(targetAnchor: segmentStackView.trailingAnchor),
            .bottom(targetAnchor: view.bottomAnchor)
        ])
        
        contentStackView.constrain([
            .top(targetAnchor: containerView.topAnchor, constant: 24),
            .leading(targetAnchor: containerView.leadingAnchor, constant: 24),
            .trailing(targetAnchor: containerView.trailingAnchor, constant: 24),
        ])
    }
    
    private func configureAbout() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        
        /// Pokédex Data
        stackView.addArrangedSubview(pokemonDataLabel)
        
        /// species
        let species = titleAndInfoFactory(title: "Species", info: viewModel.pokemonDetails.species)
        stackView.addArrangedSubview(species)
        
        /// Height
        let height = titleAndInfoFactory(title: "Height", info: .init(describing: viewModel.pokemonDetails.height))
        stackView.addArrangedSubview(height)
        
        /// Weight
        let weight = titleAndInfoFactory(title: "Weight", info: .init(describing: viewModel.pokemonDetails.weight))
        stackView.addArrangedSubview(weight)
        
        /// Abilities
        print( viewModel.pokemonDetails.abilities.map({ $0 }))
        let abilities = titleAndInfoFactory(title: "Abilities", info: viewModel.pokemonDetails.abilities.map({ $0 }).joined(separator: ", "))
        stackView.addArrangedSubview(abilities)
        
        return stackView
    }
    
    private func configureTraining() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        
        /// Training
        stackView.addArrangedSubview(trainingLabel)
        
        /// Catch rate
        let catchRate = titleAndInfoFactory(title: "Catch Rate", info: .init(describing: viewModel.pokemonDetails.catchRate))
        stackView.addArrangedSubview(catchRate)
        
        /// Base experience
        let baseExp = titleAndInfoFactory(title: "Base Exp", info: .init(describing: viewModel.pokemonDetails.baseExperience))
        stackView.addArrangedSubview(baseExp)
        
        /// Growth rate
        let growthRate = titleAndInfoFactory(title: "Growth Rate", info: viewModel.pokemonDetails.growthRate.lowercasedThenCapitalizedSentences().removingNewlinesAndFormFeeds())
        stackView.addArrangedSubview(growthRate)
        return stackView
    }
    
    private func configureWeaknesses() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        /// Type weaknesses label
        stackView.addArrangedSubview(typeWeaknessesLabel)
        let weaknessStackView = UIStackView()
        weaknessStackView.axis = .horizontal
        weaknessStackView.distribution = .fillEqually
        weaknessStackView.alignment = .fill
        weaknessStackView.spacing = 12
        weaknessStackView.translatesAutoresizingMaskIntoConstraints = false
        weaknessStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        viewModel.pokemonDetails.weaknesses.forEach { type in
            let image = PokemonType(rawValue: type.name)?.icon
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            weaknessStackView.addArrangedSubview(imageView)
        }
        weaknessStackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(weaknessStackView)
        return stackView
    }
    
    private func titleAndInfoFactory(title: String, info: String) -> UIStackView {
        /// Title
        let title = PDLabel(text: title, textColor: .black, fontWeight: .regular, fontSize: 16)
        title.textAlignment = .left
        title.numberOfLines = .zero
        /// Info
        let info = PDLabel(text: info, textColor: .black, fontWeight: .light, fontSize: 16)
        info.textAlignment = .right
        info.numberOfLines = .zero
        /// Stack View
        let stackView = UIStackView(arrangedSubviews: [title, UIView(), info])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 35
        return stackView
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
}

extension PokeDexDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0.0 {
//            headerHeightConstraint?.constant = Constants.headerHeight - scrollView.contentOffset.y
//        } else {
//            let parallaxFactor: CGFloat = 0.25
//            let offsetY = scrollView.contentOffset.y * parallaxFactor
//            let minOffsetY: CGFloat = 8.0
//            let availableOffset = min(offsetY, minOffsetY)
//            let contentRectOffsetY = availableOffset / 210
//            headerTopConstraint?.constant = view.frame.origin.y
//            headerHeightConstraint?.constant = 210 - scrollView.contentOffset.y
//            headerImageView.layer.contentsRect = CGRect(x: 0, y: -contentRectOffsetY, width: 1, height: 1)
//        }
    }
}
