//
//  PokemonService.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//

import UIKit


// MARK: - Pokemon Service
class PokemonService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
}
