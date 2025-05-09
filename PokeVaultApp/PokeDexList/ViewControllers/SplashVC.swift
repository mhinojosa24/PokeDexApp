//
//  SplashVC.swift
//  PokeVault
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit

/// A lightweight splash screen view controller responsible for handling
/// the initial app load state. It notifies its delegate once the splash
/// view has completed loading so that the app can transition to the next screen.
///
/// Typically used in coordination-based navigation to control flow from the splash screen.
class SplashVC: UIViewController {
    /// A delegate that conforms to `SplashDelegate`, used to notify
    /// when the splash screen has finished loading.
    var delegate: SplashDelegate?
    
    /// Called after the view has been loaded into memory. Sets the background
    /// color and informs the delegate that the splash screen has completed its load.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8696708083, blue: 0.6288548112, alpha: 1)
        guard let image = UIImage(named: "splash") else { return }
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(imageView)
        imageView.constrain([
            .width(240),
            .height(240),
            .centerX(targetAnchor: view.centerXAnchor),
            .centerY(targetAnchor: view.centerYAnchor)
        ])
        
        delegate?.didLoadSplash()
    }
}
