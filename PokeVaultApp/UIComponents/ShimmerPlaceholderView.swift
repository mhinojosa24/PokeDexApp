//
//  ShimmerPlaceholderView.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 5/14/25.
//

import UIKit

final class ShimmerPlaceholderView: UIView {
    private let silhouette = UIImageView(image: UIImage(named: "silhouette"))
    private let gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(silhouette)
        silhouette.contentMode = .scaleAspectFit
        silhouette.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            silhouette.topAnchor.constraint(equalTo: topAnchor),
            silhouette.bottomAnchor.constraint(equalTo: bottomAnchor),
            silhouette.leadingAnchor.constraint(equalTo: leadingAnchor),
            silhouette.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        layer.mask = gradient
        isHidden = true
    }

    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

    func startShimmer() {
        isHidden = false
        gradient.removeAllAnimations()
        gradient.frame = bounds
        gradient.colors = [UIColor(white: 0.85, alpha: 1.0).cgColor,
                           UIColor(white: 0.35, alpha: 0.35).cgColor,
                           UIColor(white: 0.85, alpha: 1.0).cgColor]
        gradient.locations = [0.0, 0.5, 1.5]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1.1, y: 1.1)
        layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }

    func stopShimmer() {
        layer.mask = nil
        gradient.removeAllAnimations()
        isHidden = true
    }
}
