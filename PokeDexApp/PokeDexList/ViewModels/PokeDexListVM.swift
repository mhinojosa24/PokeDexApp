//
//  PokeDexListVM.swift
//  PokeDexApp
//
//  Created by Maximo Hinojosa on 3/25/25.
//


protocol PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)? { get set }
    func populate() async throws
}


class PokeDexListVM: PokemonVM {
    var publisher: (([PokemonCell.UIModel]) -> Void)?
    private let service: PokemonService
    private(set) var pokemonDetailList: [PokemonDetail] = []
    
    private var pokemonInfoList: [PokemonCell.UIModel] = [] {
        didSet {
            publisher?(pokemonInfoList)
        }
    }
    
    init(service: PokemonService) {
        self.service = service
    }
    
    func populate() async throws {
        do {
            let response = try await service.fetchPokemons()
            await fetchPokemonDetails(response)
        } catch {
            throw error
        }
    }
    
    private func fetchPokemonDetails(_ fromResponse: Response) async {
        await withTaskGroup(of: PokemonDetail?.self) { [weak self] group in
            guard let self = self else { return }
            
            fromResponse.results.forEach { pokemon in
                group.addTask {
                    do {
                        return try await self.service.fetchPokemonDetail(pokemon.url)
                    } catch {
                        print(error.localizedDescription)
                        return nil
                    }
                }
            }
            
            var pokemonInfoList: [PokemonCell.UIModel] = []
            for await pokemonDetail in group {
                if let detail = pokemonDetail {
                    pokemonDetailList.append(detail)
                    pokemonInfoList.append(PokemonCell.UIModel(thunmbnail: detail.sprites.frontDefault ?? "", name: detail.name, pokedexNumber: detail.id))
                }
            }
            self.pokemonInfoList = pokemonInfoList // Triggers the publisher
        }
    }
}
