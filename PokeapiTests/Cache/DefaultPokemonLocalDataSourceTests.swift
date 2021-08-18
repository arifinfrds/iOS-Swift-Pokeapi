//
//  DefaultPokemonLocalDataSourceTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

protocol CacheClient {
    func save(_ data: Data, forKey key: String)
}

protocol PokemonLocalDataSource {
    func savePokemons(_ pokemons: [Pokemon], completion: (Result<Void, Error>) -> Void)
}

final class DefaultPokemonLocalDataSource: PokemonLocalDataSource {
    
    private let cacheClient: CacheClient
    
    init(cacheClient: CacheClient) {
        self.cacheClient = cacheClient
    }
    
    enum CacheKey: String {
        case cachePokemonList = "cache_pokemon_list"
    }
    
    func savePokemons(_ pokemons: [Pokemon], completion: (Result<Void, Error>) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: pokemons, options: .prettyPrinted)
            cacheClient.save(data, forKey: CacheKey.cachePokemonList.rawValue)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
}

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
        }
        
        private(set) var messages = [Message]()
        
        func save(_ data: Data, forKey key: String) {
            messages.append(.save(key: key))
        }
    }
    
}
