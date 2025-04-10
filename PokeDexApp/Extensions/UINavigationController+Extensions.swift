//
//  UINavigationController+Extensions.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit


extension UINavigationController {
    enum NavigationBarBackgroundAppearance {
        case opaque
        case transparent
        case none
    }
    
    func configureNavigationBarAppearance(
        barAppearance: NavigationBarBackgroundAppearance = .none,
        backgroundColor: UIColor = .clear,
        backgroundEffect: UIBlurEffect.Style = .light,
        titleColor: UIColor = .black,
        largeTitleColor: UIColor = .black,
        prefersLargeTitles: Bool = true,
        isTranslucent: Bool = true
    ) {
        let appearance = UINavigationBarAppearance()
        switch barAppearance {
        case .none:
            appearance.configureWithDefaultBackground()
        case .opaque:
            appearance.configureWithOpaqueBackground()
        case .transparent:
            appearance.configureWithTransparentBackground()
        }
        appearance.backgroundEffect = UIBlurEffect(style: backgroundEffect)
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        appearance.backgroundColor = backgroundColor
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = isTranslucent
        navigationBar.prefersLargeTitles = prefersLargeTitles
    }
}
