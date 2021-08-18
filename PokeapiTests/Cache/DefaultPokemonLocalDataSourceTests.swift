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
    func load(key: String) -> Data?
}

protocol PokemonLocalDataSource {
    func savePokemons(_ pokemons: [Pokemon], completion: (Result<Void, Error>) -> Void)
    func loadPokemons(forKey key: String, completion: (Result<[Pokemon], Error>) -> Void)
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
    
    func loadPokemons(forKey key: String, completion: (Result<[Pokemon], Error>) -> Void) {
        guard let data = cacheClient.load(key: key) else {
            completion(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Pokemon].self, from: data)
            completion(.success(decoded))
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
    
    func test_loadPokemons_loadPokemons() {
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
