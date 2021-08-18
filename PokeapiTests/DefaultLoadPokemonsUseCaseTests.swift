//
//  DefaultLoadPokemonsUseCaseTests.swift
//  DefaultLoadPokemonsUseCaseTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

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
