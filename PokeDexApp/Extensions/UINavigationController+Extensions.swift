//
//  UINavigationController+Extensions.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/2/25.
//

import UIKit


extension UINavigationController {
    func configureNavigationBarAppearance(
        backgroundEffect: UIBlurEffect.Style = .light,
        titleColor: UIColor = .black,
        largeTitleColor: UIColor = .black,
        prefersLargeTitles: Bool = true,
        isTranslucent: Bool = true
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: backgroundEffect)
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = isTranslucent
        navigationBar.prefersLargeTitles = prefersLargeTitles
    }
}
