//
//  DefaultLoadPokemonsUseCaseTests.swift
//  DefaultLoadPokemonsUseCaseTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

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
