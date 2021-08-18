//
//  LoadPokemonsUseCaseTests.swift
//  LoadPokemonsUseCaseTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

struct LoadPokemonResponse: Codable {
    let count: Int?
    let next: String?
    let results: [Pokemon]?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case next = "next"
        case results = "results"
    }
}

struct Pokemon: Codable {
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

protocol PokemonRemoteDataSource {
    func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void)
}

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

protocol LoadPokemonUseCase {
    typealias Result = Swift.Result<LoadPokemonResponse, Error>
    
    func execute(completion: @escaping (Result) -> Void)
}

final class LoadPokemonUseCaseImpl: LoadPokemonUseCase {
    
    private let pokemonRemoteDataSource: PokemonRemoteDataSource
    
    init(pokemonRemoteDataSource: PokemonRemoteDataSource) {
        self.pokemonRemoteDataSource = pokemonRemoteDataSource
    }
    
    func execute(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
        pokemonRemoteDataSource.loadPokemons(completion: completion)
    }
}

class LoadPokemonsUseCaseTests: XCTestCase {
    
    func test_execute_deliversErrorOnNetworkFail() {
        let session = URLSession(configuration: .ephemeral)
        let remoteDataSource = URLSessionPokemonRemoteDataSource(session: session)
        let sut: LoadPokemonUseCase = LoadPokemonUseCaseImpl(pokemonRemoteDataSource: remoteDataSource)
        
        sut.execute { result in
            switch result {
            case let .failure(error):
                XCTAssertEqual(error as? MockPokemonRemoteDataSource.LoadPokemonError, .networkFail)
            case let .success(loadPokemonResponse):
                XCTFail("Expect complete with error, got response : \(loadPokemonResponse) instead.")
            }
        }
    }
    
    // MARK: - Helpers
    
    private class MockPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        enum LoadPokemonError: Swift.Error {
            case networkFail
        }
        
        func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
            completion(.failure(LoadPokemonError.networkFail))
        }
        
    }
    
}
