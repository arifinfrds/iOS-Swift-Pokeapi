//
//  DefaultPokemonLocalDataSourceTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

class DefaultPokemonLocalDataSourceTests: XCTestCase {
    
    func test_savePokemons_saveGivenPokemons() {
        let (sut, cacheSpy) = makeSUT()
        
        sut.savePokemons([]) { result in
            switch result {
            case .success(()):
                break
            case .failure(let error):
                XCTFail("Expect success, got error: \(error) instead")
            }
        }
        
        XCTAssertEqual(cacheSpy.messages, [ .save(key: DefaultPokemonLocalDataSource.CacheKey.cachePokemonList.rawValue) ])
    }
    
    func test_loadPokemons_deliversEmptyPokemonsOnEmptyCache() {
        let (sut, cacheSpy) = makeSUT()
        var receivedPokemons = [Pokemon]()
        let key = DefaultPokemonLocalDataSource.CacheKey.cachePokemonList.rawValue
        
        sut.loadPokemons(forKey: key) { result in
            switch result {
            case .success(let pokemons):
                receivedPokemons.append(contentsOf: pokemons)
            case .failure(let error):
                XCTFail("Expect success, got error: \(error) instead")
            }
        }
        
        XCTAssertEqual(cacheSpy.messages, [ .load(key: key) ])
        XCTAssertEqual(receivedPokemons, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DefaultPokemonLocalDataSource, spy: CacheClientSpy) {
        let cacheSpy = CacheClientSpy()
        let sut = DefaultPokemonLocalDataSource(cacheClient: cacheSpy)
        trackForMemoryLeak(on: sut, file: file, line: line)
        return (sut, cacheSpy)
    }
    
    private class CacheClientSpy: CacheClient {
        
        enum Message: Equatable {
            case save(key: String)
            case load(key: String)
        }
        
        private(set) var messages = [Message]()
        
        func save(_ data: Data, forKey key: String) {
            messages.append(.save(key: key))
        }
        
        func load(key: String) -> Data? {
            messages.append(.load(key: key))
            return nil
        }
    }
    
}
