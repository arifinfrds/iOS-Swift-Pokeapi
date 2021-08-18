//
//  DefaultPokemonRemoteDataSource.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) { data, urlResponse, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let _ = urlResponse as? HTTPURLResponse, let receivedData = data {
                completion(.success(receivedData))
            } else {
                let error = NSError(domain: "\(type(of: DefaultPokemonRemoteDataSource.self))", code: 1, userInfo: [:])
                completion(.failure(error))
            }
        }
        .resume()
    }
}

final class DefaultPokemonRemoteDataSource: PokemonRemoteDataSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
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
