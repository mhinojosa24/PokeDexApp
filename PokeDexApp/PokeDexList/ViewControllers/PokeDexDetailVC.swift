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
    
    private lazy var modalView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9553839564, green: 0.9852878451, blue: 0.9847680926, alpha: 1)
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var thumbnail: CustomImageView = {
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
        stack.alignment = .fill
        stack.backgroundColor = .clear
        return stack
    }()
    
    // MARK: - Segment View
    
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
    
    private lazy var aboutLabel: PDLabel = {
        let label = PDLabel(text: "About", textColor: .white, fontWeight: .semiBold, fontSize: 16, backgroundColor: .clear)
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
    
    private lazy var aboutInfoView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Stats View
    
    private lazy var statsStackView: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    // MARK: - Evolution View
    
    private lazy var evolutionStackView: UIStackView = {
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setupNavigationBar()
        setupLayout()
        setupObservers()
    }
    
    // MARK: - Navigation Bar Configuration
    
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
    
    // MARK: - Auto Layout Configuration
    
    private func setupLayout() {
        scrollView.backgroundColor = PokemonBackgroundColor(rawValue: viewModel.pokemonDetails.themeColor)?.color.withAlphaComponent(0.45)
        thumbnail.imageURLString = viewModel.pokemonDetails.sprite.artwork
        aboutInfoView = AboutInfoView(model: viewModel.getAboutInfoUIModel())
        statsStackView = StatsInfoView(model: viewModel.getStatsInfoUIModel())
//        evolutionStackView = EvolutionInfoView(model: viewModel.getEvolutionInfoUIModel())
        
        aboutInfoView.tag = 0
        statsStackView.tag = 1
        statsStackView.alpha = 0
        evolutionStackView.tag = 2
        evolutionStackView.alpha = 0
        
        /// Adding subviews
        contentStackView.addArrangedSubviews([
            aboutInfoView,
            statsStackView
        ])
        
        statsStackView.isHidden = true
        evolutionStackView.isHidden = true
        
        modalView.addSubview(contentStackView)
        [thumbnail, segmentStackView, modalView].forEach({ scrollView.addSubview($0) })
        scrollView.addSubview(modalView)
        view.addSubview(scrollView)
        
        /// Scroll View
        scrollView.constrain([
            .top(targetAnchor: view.topAnchor),
            .leading(targetAnchor: view.leadingAnchor),
            .trailing(targetAnchor: view.trailingAnchor),
            .bottom(targetAnchor: view.bottomAnchor)
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
    
    private func setupObservers() {
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(didTapSegmentItem))
        aboutLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc func didTapBackButton() {
        delegate?.didTapBackButton()
    }
    
    @objc func didTapSegmentItem(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? PDLabel else { return }
        let selectedIndex = label.tag
        UIView.transition(with: contentStackView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self = self else { return }
            for case let contentView in self.contentStackView.arrangedSubviews {
                contentView.isHidden = (contentView.tag != selectedIndex)
                contentView.alpha = (contentView.tag != selectedIndex) ? 0.0 : 1.0
            }
        }, completion: nil)
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
