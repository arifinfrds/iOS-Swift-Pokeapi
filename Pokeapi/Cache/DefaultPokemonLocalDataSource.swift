//
//  DefaultPokemonLocalDataSource.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class DefaultPokemonLocalDataSource: PokemonLocalDataSource {
    
    private let cacheClient: CacheClient
    
    init(cacheClient: CacheClient) {
        self.cacheClient = cacheClient
    }
    
    enum CacheKey: String {
        case cachePokemonList = "cache_pokemon_list"
    }
    
    func savePokemons(_ pokemons: [Pokemon], completion: (Result<Void, Error>) -> Void) {
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(pokemons)
            cacheClient.save(encoded, forKey: CacheKey.cachePokemonList.rawValue)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func loadPokemons(forKey key: String, completion: (Result<[Pokemon], Error>) -> Void) {
        guard let data = cacheClient.load(key: key) else {
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Pokemon].self, from: data)
            completion(.success(decoded))
        } catch {
            completion(.failure(error))
        }
    }
    
}

