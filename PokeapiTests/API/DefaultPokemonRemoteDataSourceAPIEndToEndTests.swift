//
//  DefaultPokemonRemoteDataSourceAPIEndToEndTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

class DefaultPokemonRemoteDataSourceAPIEndToEndTests: XCTestCase {
    
    func test_loadPokemons_deliversLoadPokemonsResponse() {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let sut = DefaultPokemonRemoteDataSource(httpClient: httpClient)
        
        let exp = expectation(description: "Wait for network connection")
        var receivedLoadPokemonResponse: LoadPokemonResponse?
        sut.loadPokemons { result in
            switch result {
            case .success(let loadPokemonResponse):
                receivedLoadPokemonResponse = loadPokemonResponse
                exp.fulfill()
            case .failure(let error):
                XCTFail("Expect to success, got error \(error) instead.")
            }
        }
        wait(for: [exp], timeout: 5.0)
        
        XCTAssertNotNil(receivedLoadPokemonResponse)
    }

}
