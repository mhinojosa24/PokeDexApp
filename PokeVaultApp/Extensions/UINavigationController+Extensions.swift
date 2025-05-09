//
//  UINavigationController+Extensions.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit

enum NavigationBarBackgroundAppearance {
    case opaque
    case transparent
    case none
}

// MARK: - NavigationBarConfigurator

/// A convenience wrapper that builds a `UINavigationBarAppearance`
/// and applies it to the current navigation stack.
///
/// Usage (inside any `UIViewController`):
///
/// ```swift
/// configureNavigationBar(
///     style: .opaque,
///     background: .systemBackground,
///     title: .label,
///     largeTitle: .label,
///     tint: .systemIndigo,
///     hidesSeparator: true,
///     prefersLargeTitles: true
/// )
/// ```
extension UIViewController {
    /// Configures the navigation bar for the receiver’s navigation controller.
    ///
    /// - Parameters:
    ///   - style:  `.opaque`, `.transparent`, or `.default`.
    ///   - background:  The bar’s background color.
    ///   - title:  Standard‑title text color.
    ///   - largeTitle:  Large‑title text color.
    ///   - tint:  `tintColor` for bar‑button items.
    ///   - hidesSeparator:  Pass `true` to remove the bottom hairline.
    ///   - prefersLargeTitles:  Whether this view controller wants large titles.
    ///   - backImage:  Optional custom back indicator (SF symbol or custom asset).
    func configureNavigationBar(
        style: NavigationBarBackgroundAppearance = .opaque,
        background: UIColor = .systemBackground,
        title: UIColor = .label,
        largeTitle: UIColor = .label,
        tint: UIColor = .systemBlue,
        hidesSeparator: Bool = false,
        prefersLargeTitles: Bool = true,
        isTranslucent: Bool = false
    ) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        switch style {
        case .none:
            appearance.configureWithDefaultBackground()
        case .opaque:
            appearance.configureWithOpaqueBackground()
        case .transparent:
            appearance.configureWithTransparentBackground()
        }
        appearance.backgroundEffect = (style == .transparent) ? nil : UIBlurEffect(style: .light)
        appearance.backgroundColor = (style == .transparent || style == .opaque) ? .clear : background
        
        appearance.titleTextAttributes = [.foregroundColor: title,
                                          .font: UIFont(name: PoppinsFontWeight.semiBold.rawValue, size: 17) ?? .preferredFont(forTextStyle: .headline)]
        appearance.largeTitleTextAttributes = [.foregroundColor: largeTitle,
                                               .font: UIFont(name: PoppinsFontWeight.semiBold.rawValue, size: 34) ?? .preferredFont(forTextStyle: .largeTitle)]
        
        if hidesSeparator || style == .transparent {
            appearance.shadowColor = .clear
        }
        
        navBar.isTranslucent = isTranslucent
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = tint
        navBar.prefersLargeTitles = prefersLargeTitles
    }
}
