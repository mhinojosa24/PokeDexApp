//
//  StatsInfoView.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/26/25.
//

import UIKit


class StatsInfoView: UIStackView {

    struct UIModel {
        let name: String
        let baseValue: Int
        let minValue: Int
        let maxValue: Int
    }

    init(model: [UIModel]) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 12
        setupStats(model)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStats(_ model: [UIModel]) {
        model.forEach { stat in
            let statRow = createStatRow(stat: stat)
            addArrangedSubview(statRow)
        }
    }

    private func createStatRow(stat: UIModel) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 12
        container.alignment = .center

        let nameLabel = UILabel()
        nameLabel.text = stat.name
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textColor = .darkGray
        nameLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true

        let valueLabel = UILabel()
        valueLabel.text = "\(stat.baseValue)"
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        valueLabel.textColor = .black
        valueLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true

        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = UIColor.systemGreen.withAlphaComponent(0.6)
        progressBar.trackTintColor = UIColor.systemGray6
        progressBar.setProgress(Float(stat.baseValue) / 100.0, animated: false)

        container.addArrangedSubview(nameLabel)
        container.addArrangedSubview(valueLabel)
        container.addArrangedSubview(progressBar)

        return container
    }
}

