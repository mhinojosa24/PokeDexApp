//
//  PokeDexDetailVC.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/11/25.
//

import UIKit

/// A view controller that displays detailed information about a selected Pokémon,
/// including its About, Stats, and Evolution sections. It uses a scrollable layout
/// and segmented labels to switch between content views.
///
/// This screen is backed by a `PokeDexDetailVM` view model and communicates
/// back to a delegate when the back button is tapped.
class PokeDexDetailVC: UIViewController {
    struct Constants {
        static fileprivate let headerHeight: CGFloat = 210
    }
    // MARK: - Subviews
    
    /// Scrollable container for all child views
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    /// Rounded container holding the content stack view
    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    /// Decorative background image (Pokéball icon)
    private lazy var backgroundThumbnail: UIImageView = {
        let imageView = UIImageView(image: .init(named: "pokeball"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    /// Main Pokémon image
    private lazy var thumbnail: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
//        imageView.image = UIImage(named: "silhouette")
        return imageView
    }()
    
    /// Vertical stack containing About, Stats, and Evolution info views
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.backgroundColor = .clear
        return stack
    }()
    
    // MARK: - Segment View
    
    /// Horizontal stack for switching between About, Stats, and Evolution views
    private lazy var segmentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [aboutLabel, statsLabel, evolutionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.subviews.enumerated().forEach({ index, view in
            view.tag = index
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSegmentItem)))
        })
        return stackView
    }()
    
    /// Label for About section (default selected)
    private lazy var aboutLabel: PDLabel = {
        let label = PDLabel(text: "About", textColor: .darkNavyBlue, fontWeight: .semiBold, fontSize: 16, backgroundColor: .clear)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// Label for Stats section
    private lazy var statsLabel: PDLabel = {
        let label = PDLabel(text: "Stats", fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    /// Label for Evolution section
    private lazy var evolutionLabel: PDLabel = {
        let label = PDLabel(text: "Evolution", fontWeight: .medium, fontSize: 16, backgroundColor: .clear)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - About View
    
    private lazy var aboutInfoView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Stats View
    
    private lazy var statsInfoView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Evolution View
    
    private lazy var evolutionInfoView: UIStackView = {
        let stack = UIStackView()
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
    
    /// Called after the controller's view is loaded into memory. Sets up the nav bar, layout, and observers.
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.alpha = 0
        setupNavigationBar()
        setupLayout()
        setupObservers()
    }
    
    /// Ensures nav bar transparency is removed on appearance.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
        navigationController?.navigationBar.alpha = 1
    }
    
    // MARK: - Navigation Bar Configuration
    
    /// Configures the navigation bar with a custom back button and transparent style.
    private func setupNavigationBar() {
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
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
    
    // MARK: - Auto Layout Configuration
    
    /// Sets up layout constraints and populates content stack with the proper view models.
    private func setupLayout() {
        scrollView.backgroundColor = PokemonBackgroundColor(rawValue: viewModel.pokemonDetails.themeColor)?.color.withAlphaComponent(0.45)
        aboutLabel.textColor = PokemonBackgroundColor.darkNavyBlue.color
        thumbnail.imageURLString = viewModel.pokemonDetails.sprite.artwork
        aboutInfoView = AboutInfoView(model: viewModel.getAboutInfoUIModel())
        statsInfoView = StatsInfoView(model: viewModel.getStatsInfoUIModel())
        evolutionInfoView = EvolutionInfoView(model: viewModel.getEvolutionInfoUIModel())
        
        aboutInfoView.tag = 0
        statsInfoView.tag = 1
        evolutionInfoView.tag = 2
        
        /// Adding subviews
        contentStackView.addArrangedSubviews([
            aboutInfoView,
            statsInfoView,
            evolutionInfoView
        ])
        
        statsInfoView.isHidden = true
        evolutionInfoView.isHidden = true
        
        modalView.addSubview(contentStackView)
        [backgroundThumbnail, thumbnail, segmentStackView, modalView].forEach({ scrollView.addSubview($0) })
        scrollView.addSubview(modalView)
        view.addSubview(scrollView)
        
        /// Scroll View
        scrollView.constrain([
            .top(targetAnchor: view.topAnchor),
            .leading(targetAnchor: view.leadingAnchor),
            .trailing(targetAnchor: view.trailingAnchor),
            .bottom(targetAnchor: view.bottomAnchor)
        ])
        
        /// Background Thumbnail Image View
        backgroundThumbnail.constrain([
            .top(targetAnchor: scrollView.topAnchor),
            .trailing(targetAnchor: scrollView.trailingAnchor, constant: 8),
            .heightMultiplier(targetAnchor: view.heightAnchor, multiplier: 0.20)
        ])
        
        /// Image View
        thumbnail.constrain([
            .top(targetAnchor: scrollView.topAnchor, constant: 0),
            .centerX(targetAnchor: scrollView.centerXAnchor),
            .heightMultiplier(targetAnchor: view.heightAnchor, multiplier: 0.20)
        ])
        
        /// Segment Stack View
        segmentStackView.constrain([
            .top(targetAnchor: thumbnail.bottomAnchor),
            .leading(targetAnchor: scrollView.safeAreaLayoutGuide.leadingAnchor),
            .trailing(targetAnchor: scrollView.safeAreaLayoutGuide.trailingAnchor),
            .height(50)
        ])
        
        /// Container View
        modalView.constrain([
            .top(targetAnchor: segmentStackView.bottomAnchor),
            .leading(targetAnchor: segmentStackView.leadingAnchor),
            .trailing(targetAnchor: segmentStackView.trailingAnchor),
            .bottom(targetAnchor: view.bottomAnchor)
        ])
        
        /// Content Stack View
        contentStackView.constrain([
            .top(targetAnchor: modalView.topAnchor, constant: 24),
            .leading(targetAnchor: modalView.leadingAnchor, constant: 24),
            .trailing(targetAnchor: modalView.trailingAnchor, constant: 24),
            .bottom(targetAnchor: scrollView.bottomAnchor)
        ])
    }
    
    /// Adds gesture recognizer for segment switching.
    private func setupObservers() {
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(didTapSegmentItem))
        aboutLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    /// Handles back button tap and notifies the coordinator.
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    /// Handles tap on segment labels to switch content views.
    @objc func didTapSegmentItem(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? PDLabel else { return }
        let selectedIndex = label.tag
        for case let itemLabel as PDLabel in segmentStackView.subviews {
            let doesSelectedIndexMatch = itemLabel.tag == selectedIndex
            itemLabel.textColor = doesSelectedIndexMatch ? PokemonBackgroundColor.darkNavyBlue.color : .lightGray
            itemLabel.setPoppinsFont(weight: doesSelectedIndexMatch ? .semiBold : .medium, size: 16)
            aboutInfoView.isHidden = aboutInfoView.tag != selectedIndex
            statsInfoView.isHidden = statsInfoView.tag != selectedIndex
            evolutionInfoView.isHidden = evolutionInfoView.tag != selectedIndex
        }
    }
}
