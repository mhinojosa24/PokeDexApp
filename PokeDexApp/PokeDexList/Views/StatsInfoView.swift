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
