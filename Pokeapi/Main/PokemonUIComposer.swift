//
//  PokemonUIComposer.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import UIKit

final class UserDefaultCacheClient: CacheClient {
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func save(_ data: Data, forKey key: String) {
        defaults.set(data, forKey: key)
    }
    
    func load(key: String) -> Data? {
        defaults.data(forKey: key)
    }
    
}

final class PokemonUIComposer {
    
    static func pokemonListComposedWith() -> PokemonsViewController {
        
        let localDataSource = DefaultPokemonLocalDataSource(
            cacheClient: UserDefaultCacheClient(defaults: UserDefaults.standard)
        )
        let remoteDataSource = DefaultPokemonRemoteDataSource(
            httpClient: URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        )
        
        let useCase: LoadPokemonsUseCase = CacheableLoadPokemonsFromRemoteUseCase(
            loadPokemonFromRemoteUseCase: LoadPokemonsLocalFirstUseCase(
                localUseCase: LoadPokemonsFromLocalUseCase(localDataSource: localDataSource),
                remoteUseCase: LoadPokemonsFromRemoteUseCase(remoteDataSource: remoteDataSource)
            ),
            pokemonCache: localDataSource
        )
        
        let presenter = PokemonsPresenter(useCase: useCase)
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let identifier = "PokemonsViewController"
        let viewController = storyboard.instantiateViewController(identifier: identifier) { coder in
            return PokemonsViewController(coder: coder, presenter: presenter)
        }
        
        presenter.view = viewController
        
        return viewController
    }
    
}
