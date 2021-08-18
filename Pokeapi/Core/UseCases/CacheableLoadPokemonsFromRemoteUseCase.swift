//
//  CacheableLoadPokemonsFromRemoteUseCase.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class CacheableLoadPokemonsFromRemoteUseCase: LoadPokemonsUseCase {
    
    private let loadPokemonFromRemoteUseCase: LoadPokemonsUseCase
    private let pokemonCache: PokemonLocalDataSource
    
    init(loadPokemonFromRemoteUseCase: LoadPokemonsUseCase, pokemonCache: PokemonLocalDataSource) {
        self.loadPokemonFromRemoteUseCase = loadPokemonFromRemoteUseCase
        self.pokemonCache = pokemonCache
    }
    
    func execute(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
        loadPokemonFromRemoteUseCase.execute { [weak self] result in
            switch result {
            case let .success(loadPokemonResponse):
                completion(.success(loadPokemonResponse))
                
                guard let pokemons = loadPokemonResponse.results else {
                    return
                }
                
                self?.pokemonCache.savePokemons(pokemons) { pokemonCacheResult in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
                
            case let .failure(Error):
                completion(.failure(Error))
            }
        }
    }
}
