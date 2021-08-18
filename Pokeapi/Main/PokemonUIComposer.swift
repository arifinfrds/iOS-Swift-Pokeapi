//
//  PokemonUIComposer.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import UIKit

final class PokemonUIComposer {
    
    static func pokemonListComposedWith() -> PokemonsViewController {
        
        let createPresenter: () -> PokemonsPresenter = {
            let localDataSource = DefaultPokemonLocalDataSource(
                cacheClient: UserDefaultCacheClient(defaults: UserDefaults.standard)
            )
            let remoteDataSource = DefaultPokemonRemoteDataSource(
                httpClient: URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
            )
            
            let loadPokemonUseCase: LoadPokemonsUseCase = CacheableLoadPokemonsFromRemoteUseCase(
                loadPokemonFromRemoteUseCase: LoadPokemonsLocalFirstUseCase(
                    localUseCase: LoadPokemonsFromLocalUseCase(localDataSource: localDataSource),
                    remoteUseCase: LoadPokemonsFromRemoteUseCase(remoteDataSource: remoteDataSource)
                ),
                pokemonCache: localDataSource
            )
            
            let presenter = PokemonsPresenter(useCase: DelayedLoadPokemonsUseCaseDecorator(useCase: loadPokemonUseCase))
            return presenter
        }
        
        let presenter = createPresenter()
        
        let createView: () -> PokemonsViewController = {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let identifier = "PokemonsViewController"
            let viewController = storyboard.instantiateViewController(identifier: identifier) { coder in
                return PokemonsViewController(coder: coder, presenter: presenter)
            }
            return viewController
        }
        
        let viewController = createView()
        
        presenter.view = viewController
        
        return viewController
    }
    
}
