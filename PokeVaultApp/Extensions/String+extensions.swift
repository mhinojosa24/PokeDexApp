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
        return components(separatedBy: charactersToRemove).joined(separator: " ")
    }
    
    /// Returns a new string where the entire string is lowercased and then
    /// the first letter of each sentence is capitalized.
    ///
    /// A sentence is defined as text starting at the beginning of the string or following a period (.), exclamation point (!), or question mark (?) followed by whitespace.
    func lowercasedThenCapitalizedSentences() -> String {
        // Lowercase the entire string first.
        let lower = self.lowercased()
        
        // Pattern explanation:
        // (^|[.!?]\\s+)  -> Either the beginning of the string or one of ".!? " (with at least one whitespace)
        // ([a-z])        -> followed by a single lowercase letter (the one we want to capitalize)
        let pattern = "(^|[.!?]\\s+)([a-z])"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return lower
        }
        
        // Work with a mutable copy.
        var result = lower
        
        // Get the matches within the full range of the string.
        let range = NSRange(result.startIndex..., in: result)
        // Process matches in reverse order to avoid index shifting.
        let matches = regex.matches(in: result, options: [], range: range).reversed()
        
        for match in matches {
            // Group 2 is the letter we want to uppercase.
            let letterRange = match.range(at: 2)
            if let swiftRange = Range(letterRange, in: result) {
                let letter = result[swiftRange]
                result.replaceSubrange(swiftRange, with: letter.uppercased())
            }
        }
        
        return result
    }
}
