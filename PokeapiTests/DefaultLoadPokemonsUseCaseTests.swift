//
//  DefaultLoadPokemonsUseCaseTests.swift
//  DefaultLoadPokemonsUseCaseTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

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

final class DefaultLoadPokemonUseCase: LoadPokemonUseCase {
    
    private let pokemonRemoteDataSource: PokemonRemoteDataSource
    
    init(pokemonRemoteDataSource: PokemonRemoteDataSource) {
        self.pokemonRemoteDataSource = pokemonRemoteDataSource
    }
    
    enum LoadPokemonError: Swift.Error {
        case failToLoad
    }
    
    func execute(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
        pokemonRemoteDataSource.loadPokemons { result in
            switch result {
            case let .success(loadPokemonResponse):
                completion(.success(loadPokemonResponse))
            case let .failure(Error):
                completion(.failure(Error))
            }
        }
    }
}

class DefaultLoadPokemonsUseCaseTests: XCTestCase {
    
    func test_execute_deliversErrorOnNetworkFail() {
        let sut = makeSUT()
        var capturedErrors = [DefaultLoadPokemonUseCase.LoadPokemonError]()
        let exp = expectation(description: "Wait for load completion")
        
        sut.execute { result in
            switch result {
            case let .failure(error):
                capturedErrors.append(error as! DefaultLoadPokemonUseCase.LoadPokemonError)
                exp.fulfill()
            case let .success(loadPokemonResponse):
                XCTFail("Expect complete with error, got response : \(loadPokemonResponse) instead.")
            }
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(capturedErrors, [ .failToLoad ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LoadPokemonUseCase {
        let remoteDataSource = MockPokemonRemoteDataSource()
        let sut: LoadPokemonUseCase = DefaultLoadPokemonUseCase(pokemonRemoteDataSource: remoteDataSource)
        return sut
    }
    
    private class MockPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
            completion(.failure(DefaultLoadPokemonUseCase.LoadPokemonError.failToLoad))
        }
        
    }
    
}
