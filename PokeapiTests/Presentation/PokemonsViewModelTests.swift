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
            
            switch result {
            case let .success(loadPokemonsResponse):
                self.view.display(loadPokemonsResponse.results ?? [])
            case let .failure(error):
                self.view.display(error.localizedDescription)
            }
            self.view.display(false)
        }
    }
}

class PokemonsPresenterTests: XCTestCase {
    
    func test_viewLoaded_deliversPokemons() {
        let (sut, viewSpy) = makeSUT()
        
        sut.viewLoaded()
        
        XCTAssertEqual(viewSpy.messages, [ .displayLoading(isLading: true), .displayPokemons, .displayLoading(isLading: false) ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: PokemonsPresenter, viewSpy: PokemonsViewSpy) {
        let viewSpy = PokemonsViewSpy()
        let useCase = LoadPokemonsFromRemoteUseCase(remoteDataSource: MockSuccessPokemonRemoteDataSource())
        let sut = PokemonsPresenter(useCase: useCase, view: viewSpy)
        trackForMemoryLeak(on: sut, file: file, line: line)
        return (sut, viewSpy)
    }
    
    private class PokemonsViewSpy: PokemonsView {
        
        enum Message: Equatable {
            case displayPokemons
            case displayLoading(isLading: Bool)
            case displayMessage(message: String)
        }
        
        private(set) var messages = [Message]()
        
        func display(_ pokemons: [Pokemon]) {
            messages.append(.displayPokemons)
        }
        
        func display(_ isLoading: Bool) {
            messages.append(.displayLoading(isLading: isLoading))
        }
        
        func display(_ message: String) {
            messages.append(.displayMessage(message: message))
        }
    }
    
    private class MockSuccessPokemonRemoteDataSource: PokemonRemoteDataSource {
        
        func loadPokemons(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
            let response = LoadPokemonResponse(count: 1, next: "sample", results: [])
            completion(.success(response))
        }
        
    }
    
}
