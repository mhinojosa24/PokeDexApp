//
//  PokeDexListVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//


protocol PokemonVM {
    var publisher: (() -> Void)? { get set }
    func populate() async throws
}


class PokeDexListVM: PokemonVM {
    var publisher: (() -> Void)?
    
    func populate() async throws {
    }
}
