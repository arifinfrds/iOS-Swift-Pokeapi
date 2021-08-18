//
//  LoadPokemonsUseCase.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

enum LoadPokemonError: Swift.Error {
    case failToLoad
}

protocol LoadPokemonsUseCase {
    typealias Result = Swift.Result<LoadPokemonResponse, Error>
    
    func execute(completion: @escaping (Result) -> Void)
}
