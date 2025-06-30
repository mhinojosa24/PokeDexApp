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
    weak var delegate: PokeDexDetailDelegate?
    private let viewModel: PokeDexDetailVM
    private let detailView = PokeDexDetailView()
    
    init(viewModel: PokeDexDetailVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    /// Called after the controller's view is loaded into memory. Sets up the nav bar, layout, and observers.
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.alpha = 0
        setupNavigationBar()
        detailView.configure(with: viewModel.pokemonDetails)
        let aboutInfoView = AboutInfoView(model: viewModel.getAboutInfoUIModel())
        let statsInfoView = StatsInfoView(model: viewModel.getStatsInfoUIModel())
        let evolutionInfoView = EvolutionInfoView(model: viewModel.getEvolutionInfoUIModel())
        detailView.injectInfoViews(about: aboutInfoView, stats: statsInfoView, evolution: evolutionInfoView)
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
            tint: .white,
            hidesSeparator: true,
            prefersLargeTitles: false
        )
        
        let leftBarButtonItemAction: Selector = #selector(didTapBackButton)
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                style: .plain,
                                                target: self,
                                                action: leftBarButtonItemAction)
        leftBarButtonItem.tintColor = .white
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    /// Adds gesture recognizer for segment switching.
    private func setupObservers() {
        detailView.segmentStackView.subviews.enumerated().forEach { index, view in
            view.tag = index
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSegmentItem)))
        }
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
        for case let itemLabel as PDLabel in detailView.segmentStackView.subviews {
            let doesSelectedIndexMatch = itemLabel.tag == selectedIndex
            itemLabel.textColor = doesSelectedIndexMatch ? .white : .lightGray
            itemLabel.setPoppinsFont(weight: doesSelectedIndexMatch ? .semiBold : .medium, size: 16)
            detailView.aboutInfoView.isHidden = detailView.aboutInfoView.tag != selectedIndex
            detailView.statsInfoView.isHidden = detailView.statsInfoView.tag != selectedIndex
            detailView.evolutionInfoView.isHidden = detailView.evolutionInfoView.tag != selectedIndex
        }
    }
}
