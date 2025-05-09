//
//  UIView+Extensions.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit

extension UIView {
    /// Enum defining the LayoutAnchor that can be pinned.
    enum LayoutAnchor {
        case top(targetAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero)
        case leading(targetAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero)
        case trailing(targetAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero)
        case leadingLessThanOrEqualTo(targetAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero)
        case trailingLessThanOrEqualTo(targetAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero)
        case bottom(targetAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero)
        case width(CGFloat)
        case height(CGFloat)
        case widthMultiplier(targetAnchor: NSLayoutDimension, multiplier: CGFloat = .zero)
        case heightMultiplier(targetAnchor: NSLayoutDimension, multiplier: CGFloat = .zero)
        case centerY(targetAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero)
        case centerX(targetAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero)
    }

    
    /// Applies an array of layout constraints to the view using a declarative `LayoutAnchor` enum.
    ///
    /// This method simplifies Auto Layout by allowing you to pass a collection of `LayoutAnchor` cases
    /// which represent the types of constraints to be applied. It automatically disables `translatesAutoresizingMaskIntoConstraints`
    /// and activates each constraint.
    ///
    /// - Parameter anchors: An array of `LayoutAnchor` values defining the constraints to apply.
    ///
    /// ### Example:
    /// ```
    /// myView.constrain([
    ///     .top(targetAnchor: otherView.topAnchor, constant: 16),
    ///     .leading(targetAnchor: otherView.leadingAnchor),
    ///     .trailing(targetAnchor: otherView.trailingAnchor),
    ///     .height(44)
    /// ])
    /// ```
    func constrain(_ anchors: [LayoutAnchor]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        for anchor in anchors {
            switch anchor {
            case .top(let anchorReference, let constant):
                topAnchor.constraint(equalTo: anchorReference, constant: constant).isActive = true
            case .leading(let anchorReference, let constant):
                leadingAnchor.constraint(equalTo: anchorReference, constant: constant).isActive = true
            case .trailing(let anchorReference, let constant):
                trailingAnchor.constraint(equalTo: anchorReference, constant: -constant).isActive = true
            case .leadingLessThanOrEqualTo(let anchorReference, let constant):
                leadingAnchor.constraint(lessThanOrEqualTo: anchorReference, constant: constant).isActive = true
            case .trailingLessThanOrEqualTo(let anchorReference, let constant):
                trailingAnchor.constraint(lessThanOrEqualTo: anchorReference, constant: -constant).isActive = true
            case .bottom(let anchorReference, let constant):
                bottomAnchor.constraint(equalTo: anchorReference, constant: -constant).isActive = true
            case .width(let value):
                widthAnchor.constraint(equalToConstant: value).isActive = true
            case .height(let value):
                heightAnchor.constraint(equalToConstant: value).isActive = true
            case .widthMultiplier(let anchorReference, let multiplier):
                widthAnchor.constraint(equalTo: anchorReference, multiplier: multiplier).isActive = true
            case .heightMultiplier(let anchorReference, let multiplier):
                heightAnchor.constraint(equalTo: anchorReference, multiplier: multiplier).isActive = true
            case .centerY(let anchorReference, let constant):
                centerYAnchor.constraint(equalTo: anchorReference, constant: constant).isActive = true
            case .centerX(let anchorReference, let constant):
                centerXAnchor.constraint(equalTo: anchorReference, constant: constant).isActive = true
            }
        }
    }
}
