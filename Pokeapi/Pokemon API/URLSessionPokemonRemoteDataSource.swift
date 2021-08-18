//
//  URLSessionPokemonRemoteDataSource.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class URLSessionPokemonRemoteDataSource: PokemonRemoteDataSource {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, URLResponse, error in
            if let error = error {
                completion(.failure(error))
                return
            }
        }
        .resume()
    }
}
