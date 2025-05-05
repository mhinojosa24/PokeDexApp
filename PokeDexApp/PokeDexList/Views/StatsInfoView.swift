//
//  StatsInfoView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/26/25.
//

import UIKit


class StatsInfoView: UIStackView {

    struct UIModel {
        struct Stat {
            let name: String
            let baseValue: Int
            let minValue: Int
            let maxValue: Int
        }
        let themeColor: String
        let stats: [Stat]
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

    private func setupStats() {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        
        model.stats.forEach { stat in
            let statRow = createStatRow(stat: stat)
            container.addArrangedSubview(statRow)
        }
        let titleLabel = PDLabel(text: "Base Stats", textColor: PokemonBackgroundColor(model.themeColor), fontWeight: .semiBold, fontSize: 18)
        
        addArrangedSubviews([
            titleLabel,
            container
        ])
    }

    private func createStatRow(stat: UIModel.Stat) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center
        container.distribution = .fill

        let nameLabel = PDLabel(text: stat.name, textColor: .black, fontWeight: .regular, fontSize: 14)
        nameLabel.textAlignment = .right
        nameLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true

        let valueLabel = PDLabel(text: "\(stat.baseValue)", textColor: .black, fontWeight: .regular, fontSize: 14)

        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = PokemonBackgroundColor(model.themeColor).color
        progressBar.trackTintColor = PokemonBackgroundColor(model.themeColor).oxidized()
        progressBar.setProgress(Float(stat.baseValue) / 255.0, animated: false)

        
        let minLabel = PDLabel(text: "\(stat.minValue)", textColor: .black, fontWeight: .regular, fontSize: 14)
        minLabel.textAlignment = .right
        
        let maxLabel = PDLabel(text: "\(stat.maxValue)", textColor: .black, fontWeight: .regular, fontSize: 14)
        maxLabel.textAlignment = .right
        
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
