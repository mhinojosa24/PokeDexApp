//
//  AboutSegmentSV.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/25/25.
//

import UIKit


class AboutInfoView: UIStackView {
    struct UIModel {
        let description: String
        let themeColor: String
        let species: String
        let height: String
        let weight: String
        let abilities: [String]
        let catchRate: Int
        let baseExperience: Int
        let growthRateDescription: String
        let weaknesses: [String]
    }
    
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
    
    private func configure() {
        addArrangedSubviews([
            getTitleLabelInfo(with: model.description, color: .black, fontWeight: .light, fontSize: 16),
            getPokeDexSectionInfo(),
            getTrainingSectionInfo(),
            getWeaknessesSectionInfo()
        ])
    }
    
    private func getPokeDexSectionInfo() -> UIStackView {
        let sectionSV = getSectionSV()
        sectionSV.addArrangedSubviews([
            getTitleLabelInfo(with: "Pokédex Data", color: PokemonBackgroundColor(model.themeColor), fontWeight: .semiBold),
            getSectionInfoWith(title: "Species", subtitle: model.species),
            getSectionInfoWith(title: "Height", subtitle: .init(describing: model.height)),
            getSectionInfoWith(title: "Weight", subtitle: .init(describing: model.weight)),
            getSectionInfoWith(title: "Abilities", subtitle: model.abilities.map({ $0 }).joined(separator: ", "))
        ])
        return sectionSV
    }
    
    private func getTrainingSectionInfo() -> UIStackView {
        let sectionSV = getSectionSV()
        sectionSV.addArrangedSubviews([
            getTitleLabelInfo(with: "Training", color: PokemonBackgroundColor(model.themeColor), fontWeight: .semiBold),
            getSectionInfoWith(title: "Catch Rate", subtitle: .init(describing: model.catchRate)),
            getSectionInfoWith(title: "Base Exp", subtitle: .init(describing: model.baseExperience)),
            getSectionInfoWith(title: "Growth Rate", subtitle: model.growthRateDescription.lowercasedThenCapitalizedSentences().removingNewlinesAndFormFeeds())
        ])
        return sectionSV
    }
    
    private func getWeaknessesSectionInfo() -> UIStackView {
        let sectionSV = getSectionSV()
        let weaknessStackView = UIStackView()
        weaknessStackView.axis = .horizontal
        weaknessStackView.distribution = .fillEqually
        weaknessStackView.alignment = .leading
        weaknessStackView.spacing = 12
        weaknessStackView.translatesAutoresizingMaskIntoConstraints = false
        weaknessStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        model.weaknesses.forEach { type in
            let image = PokemonType(rawValue: type)?.icon
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            weaknessStackView.addArrangedSubview(imageView)
        }
        sectionSV.addArrangedSubviews([
            getTitleLabelInfo(with: "Weaknesses", color: PokemonBackgroundColor(model.themeColor), fontWeight: .semiBold),
            weaknessStackView,
            UIView()
        ])
        return sectionSV
    }
    
    private func getSectionInfoWith(title: String, subtitle: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 35
        stackView.addArrangedSubviews([
            getTitleLabelInfo(with: title, color: .black, fontWeight: .regular, fontSize: 16),
            getTitleLabelInfo(with: subtitle, color: .black, fontWeight: .light, fontSize: 16)
        ])
        return stackView
    }
    
    private func getSectionSV() -> UIStackView {
        let sectionSV = UIStackView()
        sectionSV.axis = .vertical
        sectionSV.distribution = .fill
        sectionSV.alignment = .fill
        sectionSV.spacing = 16
        return sectionSV
    }
    
    private func getTitleLabelInfo(with text: String, color: PokemonBackgroundColor, fontWeight: PoppinsFontWeight, fontSize: CGFloat = 18) -> PDLabel {
        let titleLabel: PDLabel = .init(text: text, textColor: color, fontWeight: fontWeight, fontSize: fontSize)
        titleLabel.numberOfLines = .zero
        titleLabel.textAlignment = .left
        return titleLabel
    }
}
