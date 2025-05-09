//
//  UIStackView+Extensions.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/25/25.
//

import UIKit

extension UIStackView {
    /// Adds an array of views to the arrangedSubviews of this stack view.
    ///
    /// - Parameter views: The views to add as arranged subviews.
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
