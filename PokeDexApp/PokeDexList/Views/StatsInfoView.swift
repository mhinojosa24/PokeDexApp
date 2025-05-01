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

    init(model: UIModel) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 20
        setupStats(model)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStats(_ model: UIModel) {
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
        nameLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true

        let valueLabel = PDLabel(text: "\(stat.baseValue)", textColor: .black, fontWeight: .regular, fontSize: 14)

        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = UIColor.systemGreen.withAlphaComponent(0.6)
        progressBar.trackTintColor = UIColor.systemGray6
        progressBar.setProgress(Float(stat.baseValue) / 100.0, animated: false)

        
        let minLabel = PDLabel(text: "\(stat.minValue)", textColor: .black, fontWeight: .regular, fontSize: 14)
        minLabel.contentMode = .right
        
        let maxLabel = PDLabel(text: "\(stat.maxValue)", textColor: .black, fontWeight: .regular, fontSize: 14)
        maxLabel.contentMode = .right
        
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

