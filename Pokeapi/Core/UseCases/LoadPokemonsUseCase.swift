//
//  LoadPokemonsUseCase.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

protocol LoadPokemonsUseCase {
    typealias Result = Swift.Result<LoadPokemonResponse, Error>
    
    func execute(completion: @escaping (Result) -> Void)
}

final class DefaultLoadPokemonsUseCase: LoadPokemonsUseCase {
    
    private let pokemonRemoteDataSource: PokemonRemoteDataSource
    
    init(pokemonRemoteDataSource: PokemonRemoteDataSource) {
        self.pokemonRemoteDataSource = pokemonRemoteDataSource
    }
    
    enum LoadPokemonError: Swift.Error {
        case failToLoad
    }
    
    func execute(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
        pokemonRemoteDataSource.loadPokemons { result in
            switch result {
            case let .success(loadPokemonResponse):
                completion(.success(loadPokemonResponse))
            case let .failure(Error):
                completion(.failure(Error))
            }
        }
    }
}

final class LoadPokemonsLocalFirstUseCase: LoadPokemonsUseCase {
    
    private let localUseCase: LoadPokemonsUseCase
    private let remoteUseCase: LoadPokemonsUseCase
    
    init(localUseCase: LoadPokemonsUseCase, remoteUseCase: LoadPokemonsUseCase) {
        self.localUseCase = localUseCase
        self.remoteUseCase = remoteUseCase
    }
    
    func execute(completion: @escaping (DefaultLoadPokemonsUseCase.Result) -> Void) {
        executeLocalUseCase(onCompleted: { [weak self] localResult in
            completion(localResult)
            
            self?.executeRemoteUseCase(onCompleted: { remoteResult in
                completion(remoteResult)
            })
        })
    }
    
    private func executeLocalUseCase(onCompleted: @escaping (DefaultLoadPokemonsUseCase.Result) -> Void) {
        localUseCase.execute { result in
            switch result {
            case .success(let response):
                onCompleted(.success(response))
            case .failure(let error):
                onCompleted(.failure(error))
            }
        }
    }
    
    private func executeRemoteUseCase(onCompleted: @escaping (DefaultLoadPokemonsUseCase.Result) -> Void) {
        remoteUseCase.execute { result in
            switch result {
            case .success(let response):
                onCompleted(.success(response))
            case .failure(let error):
                onCompleted(.failure(error))
            }
        }
    }
}
