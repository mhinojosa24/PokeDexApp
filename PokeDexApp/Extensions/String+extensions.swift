//
//  String+extensions.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 4/9/25.
//

import Foundation


extension String {
    /// Returns a new string with newline ("\n") and form feed ("\f") characters removed.
    func removingNewlinesAndFormFeeds() -> String {
        let charactersToRemove = CharacterSet(charactersIn: "\n\u{000C}")
        return components(separatedBy: charactersToRemove).joined()
    }
}
