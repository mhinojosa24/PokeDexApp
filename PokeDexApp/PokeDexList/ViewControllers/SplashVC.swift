//
//  SplashVC.swift
//  PokeDexApp
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
        view.backgroundColor = .white
        delegate?.didLoadSplash()
    }
}
