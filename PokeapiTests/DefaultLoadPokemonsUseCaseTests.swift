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
        let sut = makeSUT(remoteDataSource: MockErrorPokemonRemoteDataSource())
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
    
    func test_execute_deliversEmptyPokemonList() {
        let sut = makeSUT(remoteDataSource: MockSuccessPokemonRemoteDataSource())
        var capturedPokemons = [Pokemon]()
        let exp = expectation(description: "Wait for load completion")
        
        sut.execute { result in
            switch result {
            case .success(let loadPokemonResponse):
                capturedPokemons = loadPokemonResponse.results ?? []
                exp.fulfill()
            case .failure(let error):
                XCTFail("Expect complete with success, got error : \(error) instead.")
            }
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(capturedPokemons, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(remoteDataSource: PokemonRemoteDataSource, file: StaticString = #filePath, line: UInt = #line) -> LoadPokemonUseCase {
        let sut = DefaultLoadPokemonUseCase(pokemonRemoteDataSource: remoteDataSource)
        trackForMemoryLeak(on: sut)
        return sut
    }
    
    private class MockErrorPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
            completion(.failure(DefaultLoadPokemonUseCase.LoadPokemonError.failToLoad))
        }
        
    }
    
    private class MockSuccessPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        func loadPokemons(completion: @escaping (LoadPokemonUseCase.Result) -> Void) {
            let response = LoadPokemonResponse(count: 1, next: "sample", results: [])
            completion(.success(response))
        }
        
    }
    
}
