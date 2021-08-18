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
        
        XCTAssertEqual(collaboratorSpy.messages, [ .execute, .execute ])
        XCTAssertEqual(receivedLoadPokemonResponse?.count, 0)
        XCTAssertEqual(receivedLoadPokemonResponse?.results, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LoadPokemonsUseCase, collaboratorSpy: CollaboratorUseCaseSpy) {
        let collaboratorUseCaseSpy = CollaboratorUseCaseSpy()
        let sut = LoadPokemonsLocalFirstUseCase(
            localUseCase: collaboratorUseCaseSpy,
            remoteUseCase: collaboratorUseCaseSpy
        )
        trackForMemoryLeak(on: sut)
        return (sut, collaboratorUseCaseSpy)
    }
    
    private func defaultTimeout() -> TimeInterval {
        0.1
    }
    
    private class CollaboratorUseCaseSpy: LoadPokemonsUseCase {
        
        enum Message {
            case execute
        }
        
        private(set) var messages = [Message]()
        
        func execute(completion: @escaping (LoadPokemonsFromRemoteUseCase.Result) -> Void) {
            messages.append(.execute)
            let mockResponse = LoadPokemonResponse(count: 0 , next: nil, results: [])
            completion(.success(mockResponse))
        }
    }
    
}
