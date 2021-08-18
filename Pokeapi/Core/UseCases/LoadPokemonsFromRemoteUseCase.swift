//
//  LoadPokemonsFromRemoteUseCase.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class LoadPokemonsFromRemoteUseCase: LoadPokemonsUseCase {
    
    private let remoteDataSource: PokemonRemoteDataSource
    
    init(remoteDataSource: PokemonRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    enum LoadPokemonError: Swift.Error {
        case failToLoad
    }
    
    func execute(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
        remoteDataSource.loadPokemons { result in
            switch result {
            case let .success(loadPokemonResponse):
                completion(.success(loadPokemonResponse))
            case let .failure(Error):
                completion(.failure(Error))
            }
        }
    }
}
