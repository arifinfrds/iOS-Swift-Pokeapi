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
            
            if let httpResponse = URLResponse as? HTTPURLResponse, let receivedData = data {
                if httpResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(LoadPokemonResponse.self, from: receivedData)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                let error = NSError(domain: "\(type(of: URLSessionPokemonRemoteDataSource.self))", code: 1, userInfo: [:])
                completion(.failure(error))
            }
        }
        .resume()
    }
}
