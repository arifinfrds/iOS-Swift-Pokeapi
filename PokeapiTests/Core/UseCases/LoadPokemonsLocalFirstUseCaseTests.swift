//
//  LoadPokemonsLocalFirstUseCaseTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

class LoadPokemonsLocalFirstUseCaseTests: XCTestCase {
    
    func test_execute_executeFromLocalThenRemoteInSequence() {
        let (sut, collaboratorSpy) = makeSUT()
        var receivedLoadPokemonResponse: LoadPokemonResponse?
        let exp = expectation(description: "Wait for completion")
        exp.expectedFulfillmentCount = 2
        
        sut.execute { result in
            switch result {
            case .success(let response):
                receivedLoadPokemonResponse = response
                exp.fulfill()
            case .failure(let error):
                XCTFail("expect success, got error: \(error) instead.")
            }
        }
        wait(for: [exp], timeout: defaultTimeout())
        
        XCTAssertEqual(collaboratorSpy.messages, [ .execute, .execute, .savePokemons ])
        XCTAssertEqual(receivedLoadPokemonResponse?.count, 0)
        XCTAssertEqual(receivedLoadPokemonResponse?.results, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LoadPokemonsUseCase, collaboratorSpy: CollaboratorSpy) {
        let collaboratorSpy = CollaboratorSpy()
        let sut = LoadPokemonsLocalFirstUseCase(
            localUseCase: collaboratorSpy,
            remoteUseCase: CacheableLoadPokemonsFromRemoteUseCase(
                loadPokemonFromRemoteUseCase: collaboratorSpy,
                pokemonCache: collaboratorSpy
            )
        )
        trackForMemoryLeak(on: sut)
        return (sut, collaboratorSpy)
    }
    
    private func defaultTimeout() -> TimeInterval {
        0.1
    }
    
    private class CollaboratorSpy: LoadPokemonsUseCase, PokemonLocalDataSource {
        
        enum Message {
            case execute
            case savePokemons
            case loadPokemons
        }
        
        private(set) var messages = [Message]()
        
        func execute(completion: @escaping (LoadPokemonsFromRemoteUseCase.Result) -> Void) {
            messages.append(.execute)
            let mockResponse = LoadPokemonResponse(count: 0 , next: nil, results: [])
            completion(.success(mockResponse))
        }
        
        func savePokemons(_ pokemons: [Pokemon], completion: (Result<Void, Error>) -> Void) {
            messages.append(.savePokemons)
            completion(.success(()))
        }
        
        func loadPokemons(forKey key: String, completion: (Result<[Pokemon], Error>) -> Void) {
            messages.append(.loadPokemons)
            completion(.success([]))
        }
    }
    
}
