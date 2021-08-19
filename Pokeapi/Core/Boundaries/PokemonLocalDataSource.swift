//
//  PokemonLocalDataSource.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

protocol PokemonLocalDataSource {
    func savePokemons(_ pokemons: [Pokemon], completion: (Result<Void, Error>) -> Void)
    func loadPokemons(forKey key: String, completion: (Result<[Pokemon], Error>) -> Void)
}
