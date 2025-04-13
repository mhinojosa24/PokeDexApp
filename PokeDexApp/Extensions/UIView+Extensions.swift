//
//  UIView+Extensions.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit

extension UIView {
    /// Enum defining the edges that can be pinned.
    enum Edge {
        case top(CGFloat, useSafeArea: Bool = false)
        case leading(CGFloat, useSafeArea: Bool = false)
        case trailing(CGFloat, useSafeArea: Bool = false)
        case leadingLessThanOrEqualTo(CGFloat, useSafeArea: Bool = false)
        case trailingLessThanOrEqualTo(CGFloat, useSafeArea: Bool = false)
        case bottom(CGFloat, useSafeArea: Bool = false)
        case width(CGFloat)
        case height(CGFloat)
        case widthMultiplier(CGFloat)
        case heightMultiplier(CGFloat)
        case centerY(CGFloat, useSafeArea: Bool = false)
        case centerX(CGFloat, useSafeArea: Bool = false)
    }

    /// Constraints the view to specified edges of a given superview with optional width and height constraints.
    /// - Parameters:
    ///   - superview: The parent view to constrain to.
    ///   - edges: A list of edges to pin with corresponding insets.
    ///   - useSafeArea: A Boolean value indicating whether to use the safe area layout guide.
    func constrain(to superview: UIView, edges: [Edge]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        for edge in edges {
            switch edge {
            case .top(let inset, let useSafeArea):
                let topAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
                topAnchor.constraint(equalTo: topAnchorReference, constant: inset).isActive = true
            case .leading(let inset, let useSafeArea):
                let leadingAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
                leadingAnchor.constraint(equalTo: leadingAnchorReference, constant: inset).isActive = true
            case .trailing(let inset, let useSafeArea):
                let trailingAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
                trailingAnchor.constraint(equalTo: trailingAnchorReference, constant: -inset).isActive = true
            case .leadingLessThanOrEqualTo(let inset, let useSafeArea):
                let leadingLessThanOrEqualToAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
                leadingAnchor.constraint(lessThanOrEqualTo: leadingLessThanOrEqualToAnchorReference, constant: inset).isActive = true
            case .trailingLessThanOrEqualTo(let inset, let useSafeArea):
                let trailingLessThanOrEqualToAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
                trailingAnchor.constraint(lessThanOrEqualTo: trailingLessThanOrEqualToAnchorReference, constant: -inset).isActive = true
            case .bottom(let inset, let useSafeArea):
                let bottomAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
                bottomAnchor.constraint(equalTo: bottomAnchorReference, constant: -inset).isActive = true
            case .width(let value):
                widthAnchor.constraint(equalToConstant: value).isActive = true
            case .height(let value):
                heightAnchor.constraint(equalToConstant: value).isActive = true
            case .widthMultiplier(let multiplier):
                widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: multiplier).isActive = true
            case .heightMultiplier(let multiplier):
                heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: multiplier).isActive = true
            case .centerY(let value, let useSafeArea):
                let centerYAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.centerYAnchor : superview.centerYAnchor
                centerYAnchor.constraint(equalTo: centerYAnchorReference, constant: value).isActive = true
            case .centerX(let value, let useSafeArea):
                let centerXAnchorReference: NSLayoutAnchor = useSafeArea ? superview.safeAreaLayoutGuide.centerXAnchor : superview.centerXAnchor
                centerXAnchor.constraint(equalTo: centerXAnchorReference, constant: value).isActive = true
            }
        }
    }
}
