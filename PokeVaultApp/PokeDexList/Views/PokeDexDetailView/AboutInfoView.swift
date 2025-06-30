//
//  AboutSegmentSV.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/25/25.
//

import UIKit


/// A vertically stacked view that presents structured information about a Pokémon,
/// including its description, Pokédex data, training details, and weaknesses.
///
/// This view is designed to be used inside a scrollable context and adapts
/// dynamically to the data provided through the `UIModel`.
class AboutInfoView: UIStackView {
    /// A view model that holds all the data required to configure an `AboutInfoView`.
    struct UIModel {
        let description: String               // Short description or flavor text
        let themeColor: String                // Optional color theme identifier
        let species: String                   // Pokémon species name
        let height: String                    // Formatted height string
        let weight: String                    // Formatted weight string
        let abilities: [String]               // List of ability names
        let catchRate: Int                    // Catch rate value
        let baseExperience: Int               // Base XP gained from defeating this Pokémon
        let growthRateDescription: String     // Growth rate description
        let weaknesses: [String]              // List of Pokémon type weaknesses
    }
    
    private lazy var weaknessCollectionView: IntrinsicSizeCollectionView = {
        let collectionViewLayout = WrappingFlowLayout()
        let collectionView = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.register(WeaknessTypeCell.self, forCellWithReuseIdentifier: WeaknessTypeCell.identifier)
        return collectionView
    }()
    
    private var model: UIModel
    
    init(model: UIModel) {
        self.model = model
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fill
        alignment = .fill
        backgroundColor = .clear
        spacing = 32
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures the layout and content of the view using the provided model.
    /// Adds title, Pokédex data, training section, and weaknesses collection.
    private func configure() {
        addArrangedSubviews([
            getTitleLabelInfo(with: model.description, color: .darkNavyBlue, fontWeight: .light, fontSize: 16),
            getPokeDexSectionInfo(),
            getTrainingSectionInfo(),
            getWeaknessesSectionInfo()
        ])
        weaknessCollectionView.reloadData()
    }
    
    /// Creates and returns a stack view containing Pokédex-related info
    /// such as species, height, weight, and abilities.
    private func getPokeDexSectionInfo() -> UIStackView {
        let sectionSV = getSectionSV()
        sectionSV.addArrangedSubviews([
            getTitleLabelInfo(with: "Pokédex Data", color: .darkNavyBlue, fontWeight: .semiBold),
            getSectionInfoWith(title: "Species", subtitle: model.species),
            getSectionInfoWith(title: "Height", subtitle: .init(describing: model.height)),
            getSectionInfoWith(title: "Weight", subtitle: .init(describing: model.weight)),
            getSectionInfoWith(title: "Abilities", subtitle: model.abilities.map({ $0 }).joined(separator: ", "))
        ])
        return sectionSV
    }
    
    /// Creates and returns a stack view for training-related info
    /// such as catch rate, base experience, and growth rate.
    private func getTrainingSectionInfo() -> UIStackView {
        let sectionSV = getSectionSV()
        sectionSV.addArrangedSubviews([
            getTitleLabelInfo(with: "Training", color: .darkNavyBlue, fontWeight: .semiBold),
            getSectionInfoWith(title: "Catch Rate", subtitle: .init(describing: model.catchRate)),
            getSectionInfoWith(title: "Base Exp", subtitle: .init(describing: model.baseExperience)),
            getSectionInfoWith(title: "Growth Rate", subtitle: model.growthRateDescription.lowercasedThenCapitalizedSentences().removingNewlinesAndFormFeeds())
        ])
        return sectionSV
    }
    
    /// Creates and returns a stack view for displaying the Pokémon's weaknesses
    /// using a custom, non-scrollable collection view.
    private func getWeaknessesSectionInfo() -> UIStackView {
        let sectionSV = getSectionSV()
        sectionSV.addArrangedSubviews([
            getTitleLabelInfo(with: "Weaknesses", color: .darkNavyBlue, fontWeight: .semiBold),
            weaknessCollectionView
        ])
        return sectionSV
    }
    
    /// Creates a horizontal stack view that displays a title on the left
    /// and its corresponding value on the right.
    ///
    /// - Parameters:
    ///   - title: The label for the stat or descriptor (e.g. "Height").
    ///   - subtitle: The value associated with the title (e.g. "0.7 m").
    /// - Returns: A configured horizontal `UIStackView` containing the title and value.
    private func getSectionInfoWith(title: String, subtitle: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 35
        stackView.addArrangedSubviews([
            getTitleLabelInfo(with: title, color: .gray, fontWeight: .regular, fontSize: 16),
            getTitleLabelInfo(with: subtitle, color: .darkNavyBlue, fontWeight: .light, fontSize: 16)
        ])
        return stackView
    }
    
    /// Creates and returns a vertical stack view preconfigured with spacing, axis, and alignment
    /// used to layout a group of section rows in the About screen.
    /// - Returns: A vertical `UIStackView` with default layout configuration.
    private func getSectionSV() -> UIStackView {
        let sectionSV = UIStackView()
        sectionSV.axis = .vertical
        sectionSV.distribution = .fill
        sectionSV.alignment = .fill
        sectionSV.spacing = 16
        return sectionSV
    }
    
    /// Creates and returns a custom `PDLabel` configured with the provided text, color, font weight,
    /// and font size. The label supports multiple lines and left-aligned text.
    ///
    /// - Parameters:
    ///   - text: The string to display.
    ///   - color: The text color using app-specific color styling.
    ///   - fontWeight: The font weight using the `PoppinsFontWeight` enum.
    ///   - fontSize: The font size (default is 18).
    /// - Returns: A configured `PDLabel`.
    private func getTitleLabelInfo(with text: String, color: PokemonBackgroundColor, fontWeight: PoppinsFontWeight, fontSize: CGFloat = 18) -> PDLabel {
        let titleLabel: PDLabel = .init(text: text, textColor: color, fontWeight: fontWeight, fontSize: fontSize)
        titleLabel.numberOfLines = .zero
        titleLabel.textAlignment = .left
        return titleLabel
    }
}

// MARK: - UICollectionViewDataSource for Weaknesses
extension AboutInfoView: UICollectionViewDataSource {
    /// Returns the number of weakness items to display in the collection view.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.weaknesses.count
    }
    
    /// Dequeues and configures a `WeaknessTypeCell` for each weakness type.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeaknessTypeCell.identifier, for: indexPath) as? WeaknessTypeCell else {
            return UICollectionViewCell()
        }
        
        let weakness = model.weaknesses[indexPath.item]
        cell.configure(type: weakness)
        return cell
    }
}
