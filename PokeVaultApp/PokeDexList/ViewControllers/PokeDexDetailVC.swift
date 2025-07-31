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
        configureViews()
        setupNavigationBar()
        setupGestureRecognizers()
    }
    
    private func configureViews() {
        detailView.configure(with: viewModel.pokemonDetails)
        let aboutInfoView = AboutInfoView(model: viewModel.getAboutInfoUIModel())
        let statsInfoView = StatsInfoView(model: viewModel.getStatsInfoUIModel())
        let evolutionInfoView = EvolutionInfoView(model: viewModel.getEvolutionInfoUIModel())
        detailView.injectInfoViews(about: aboutInfoView, stats: statsInfoView, evolution: evolutionInfoView)
    }
    
    // MARK: - Navigation Bar Configuration
    
    /// Configures the navigation bar with a custom back button and transparent style.
    private func setupNavigationBar() {
        view.backgroundColor = PVColor.icyWhite.color
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
    }
    
    /// Adds gesture recognizer for segment switching.
    private func setupGestureRecognizers() {
        detailView.segmentStackView.subviews.forEach { view in
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSegment)))
        }
    }
    
    /// Handles tap on segment labels to switch content views.
    @objc func didTapSegment(_ sender: UITapGestureRecognizer) {
        guard let selectedTag = sender.view?.tag else { return }
        detailView.selectSegment(at: selectedTag)
    }
}
