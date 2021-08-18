//
//  PokemonsViewModelTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

protocol PokemonsView {
    func display(_ pokemons: [Pokemon])
    func display(_ isLoading: Bool)
    func display(_ message: String)
}

protocol PokemonsPresenterInput {
    func viewLoaded()
}

final class PokemonsPresenter: PokemonsPresenterInput {
    
    private let useCase: LoadPokemonsUseCase
    private let view: PokemonsView
    
    init(useCase: LoadPokemonsUseCase, view: PokemonsView) {
        self.useCase = useCase
        self.view = view
    }
    
    func viewLoaded() {
        view.display(true)
        useCase.execute { [weak self] result in
            guard let self = self else { return }
            
            self.view.display(false)
            
            switch result {
            case let .success(loadPokemonsResponse):
                self.view.display(loadPokemonsResponse.results ?? [])
            case let .failure(error):
                self.view.display(error.localizedDescription)
            }
        }
    }
}

class PokemonsPresenterTests: XCTestCase {
    
    func test_viewLoaded_deliversPokemons() {
        let useCase = LoadPokemonsFromRemoteUseCase(remoteDataSource: MockSuccessPokemonRemoteDataSource())
        let (sut, viewSpy) = makeSUT(useCase: useCase)
        
        sut.viewLoaded()
        
        XCTAssertEqual(viewSpy.messages, [ .displayLoading(isLading: true), .displayLoading(isLading: false), .displayPokemons ])
    }
    
    func test_viewLoaded_deliversErrorMessage() {
        let useCase = LoadPokemonsFromRemoteUseCase(remoteDataSource: MockErrorPokemonRemoteDataSource())
        let (sut, viewSpy) = makeSUT(useCase: useCase)
        
        sut.viewLoaded()
        
        XCTAssertEqual(viewSpy.messages, [ .displayLoading(isLading: true), .displayLoading(isLading: false), .displayMessage ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(useCase: LoadPokemonsFromRemoteUseCase, file: StaticString = #filePath, line: UInt = #line) -> (sut: PokemonsPresenter, viewSpy: PokemonsViewSpy) {
        let viewSpy = PokemonsViewSpy()
        let sut = PokemonsPresenter(useCase: useCase, view: viewSpy)
        trackForMemoryLeak(on: sut, file: file, line: line)
        return (sut, viewSpy)
    }
    
    private class PokemonsViewSpy: PokemonsView {
        
        enum Message: Equatable {
            case displayPokemons
            case displayLoading(isLading: Bool)
            case displayMessage
        }
        
        private(set) var messages = [Message]()
        
        func display(_ pokemons: [Pokemon]) {
            messages.append(.displayPokemons)
        }
        
        func display(_ isLoading: Bool) {
            messages.append(.displayLoading(isLading: isLoading))
        }
        
        func display(_ message: String) {
            messages.append(.displayMessage)
        }
    }
    
    private class MockSuccessPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        func loadPokemons(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
            let response = LoadPokemonResponse(count: 1, next: "sample", results: [])
            completion(.success(response))
        }
        
    }
    
    private class MockErrorPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        func loadPokemons(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
            completion(.failure(LoadPokemonError.failToLoad))
        }
        
    }
    
}
