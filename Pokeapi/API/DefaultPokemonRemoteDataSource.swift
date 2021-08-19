//
//  DefaultPokemonRemoteDataSource.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class DefaultPokemonRemoteDataSource: PokemonRemoteDataSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadPokemons(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        httpClient.get(from: url) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let decoded = try decoder.decode(LoadPokemonResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
