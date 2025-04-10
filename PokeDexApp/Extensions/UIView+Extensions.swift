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
        case top(CGFloat)
        case leading(CGFloat)
        case trailing(CGFloat)
        case bottom(CGFloat)
        case width(CGFloat)
        case height(CGFloat)
        case widthMultiplier(CGFloat)
        case heightMultiplier(CGFloat)
    }

    /// Constraints the view to specified edges of a given superview with optional width and height constraints.
    /// - Parameters:
    ///   - superview: The parent view to constrain to.
    ///   - edges: A list of edges to pin with corresponding insets.
    ///   - useSafeArea: A Boolean value indicating whether to use the safe area layout guide.
    func constrain(to superview: UIView, edges: [Edge], useSafeArea: Bool = false) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchorReference: NSLayoutYAxisAnchor = useSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let bottomAnchorReference: NSLayoutYAxisAnchor = useSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
        let leadingAnchorReference: NSLayoutXAxisAnchor = useSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
        let trailingAnchorReference: NSLayoutXAxisAnchor = useSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
        
        for edge in edges {
            switch edge {
            case .top(let inset):
                topAnchor.constraint(equalTo: topAnchorReference, constant: inset).isActive = true
            case .leading(let inset):
                leadingAnchor.constraint(equalTo: leadingAnchorReference, constant: inset).isActive = true
            case .trailing(let inset):
                trailingAnchor.constraint(equalTo: trailingAnchorReference, constant: -inset).isActive = true
            case .bottom(let inset):
                bottomAnchor.constraint(equalTo: bottomAnchorReference, constant: -inset).isActive = true
            case .width(let value):
                widthAnchor.constraint(equalToConstant: value).isActive = true
            case .height(let value):
                heightAnchor.constraint(equalToConstant: value).isActive = true
            case .widthMultiplier(let multiplier):
                widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: multiplier).isActive = true
            case .heightMultiplier(let multiplier):
                heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: multiplier).isActive = true
            }
        }
    }
}
