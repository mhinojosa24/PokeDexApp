//
//  StatsInfoView.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/26/25.
//

import UIKit

/// A vertical stack view that displays Pokémon base stat information, including
/// base values, min/max estimations, and a progress bar visualization.
/// 
/// This view is initialized with a `UIModel`, which provides both a theme color
/// and a list of stats. The view will include:
/// - A section title
/// - A list of horizontal rows (each showing one stat’s name, value, bar, min, and max)
/// - A total row that sums all base stats.
///
/// - Note: Progress bars are scaled using a max base stat of 255 to maintain proportionality.
class StatsInfoView: UIStackView {

    /// A UI model representing the visual configuration of stat data.
    struct UIModel {
        struct Stat {
            let name: String          // The name of the stat (e.g. "HP", "Attack").
            let baseValue: Int        // The base stat value from the API.
            let minValue: Int         // Calculated minimum stat value at level 100.
            let maxValue: Int         // Calculated maximum stat value at level 100.
        }
        let themeColor: String       // Used to theme the progress bars.
        let stats: [Stat]            // Collection of stat rows to be displayed.
    }

    private var model: UIModel
    
    init(model: UIModel) {
        self.model = model
        super.init(frame: .zero)
        axis = .vertical
        spacing = 20
        setupStats()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Assembles the UI by stacking each stat row, along with a summary row and title.
    private func setupStats() {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        
        model.stats.forEach { stat in
            let statRow = createStatRow(stat: stat)
            container.addArrangedSubview(statRow)
        }
        let totalContainer = UIStackView()
        totalContainer.axis = .horizontal
        totalContainer.spacing = 12
        totalContainer.alignment = .center
        totalContainer.distribution = .fill
        
        let totalLabel = PDLabel(text: "Total", textColor: .gray, fontWeight: .regular, fontSize: 14)
        totalLabel.textAlignment = .left
        totalLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let sum = model.stats.reduce(0) { partialResult, stat in
            return partialResult + stat.baseValue
        }
        let valueLabel = PDLabel(text: "\(sum)", textColor: .gray, fontWeight: .semiBold, fontSize: 14)
        valueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let minTitleLabel = PDLabel(text: "Min", textColor: .gray, fontWeight: .regular, fontSize: 14)
        minTitleLabel.textAlignment = .right
        minTitleLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let maxTitleLabel = PDLabel(text: "Max", textColor: .gray, fontWeight: .regular, fontSize: 14)
        maxTitleLabel.textAlignment = .right
        maxTitleLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalContainer.addArrangedSubviews([
            totalLabel,
            valueLabel,
            UIView(),
            minTitleLabel,
            maxTitleLabel
        ])
        
        container.addArrangedSubview(totalContainer)
        
        let titleLabel = PDLabel(text: "Base Stats", textColor: .darkNavyBlue, fontWeight: .semiBold, fontSize: 18)
        
        addArrangedSubviews([
            titleLabel,
            container
        ])
    }

    /// Creates a single horizontal row showing one stat’s name, base value, a progress bar,
    /// and min/max values.
    ///
    /// - Parameter stat: The stat model for the row.
    /// - Returns: A configured UIView representing a stat line.
    private func createStatRow(stat: UIModel.Stat) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center
        container.distribution = .fill

        let nameLabel = PDLabel(text: stat.name, textColor: .gray, fontWeight: .regular, fontSize: 14)
        nameLabel.textAlignment = .left
        nameLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true

        let valueLabel = PDLabel(text: "\(stat.baseValue)", textColor: .darkNavyBlue, fontWeight: .regular, fontSize: 14)
        valueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = PokemonBackgroundColor(model.themeColor).color
        progressBar.trackTintColor = PokemonBackgroundColor(model.themeColor).oxidized()
        progressBar.setProgress(Float(stat.baseValue) / 255.0, animated: false)

        
        let minLabel = PDLabel(text: "\(stat.minValue)", textColor: .darkNavyBlue, fontWeight: .regular, fontSize: 14)
        minLabel.textAlignment = .right
        minLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let maxLabel = PDLabel(text: "\(stat.maxValue)", textColor: .darkNavyBlue, fontWeight: .regular, fontSize: 14)
        maxLabel.textAlignment = .right
        maxLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        container.addArrangedSubviews([
            nameLabel,
            valueLabel,
            progressBar,
            minLabel,
            maxLabel
        ])
        
        return container
    }
}
