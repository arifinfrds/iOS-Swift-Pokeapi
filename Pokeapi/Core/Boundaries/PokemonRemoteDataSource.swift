//
//  PokemonRemoteDataSource.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

protocol PokemonRemoteDataSource {
    func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void)
}
