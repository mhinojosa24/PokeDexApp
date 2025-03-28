//
//  SplashVC.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/27/25.
//

import UIKit


class SplashVC: UIViewController {
    var delegate: SplashDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        delegate?.didLoadSplash()
    }
}
