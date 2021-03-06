//
//  PokemonsPresenterTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest
@testable import Pokeapi

class PokemonsPresenterTests: XCTestCase {
    
    func test_viewLoaded_deliversPokemons() {
        let useCase = LoadPokemonsFromRemoteUseCase(remoteDataSource: MockSuccessPokemonRemoteDataSource())
        let (sut, viewSpy) = makeSUT(useCase: useCase)
        
        sut.viewLoaded()
        
        XCTAssertEqual(viewSpy.messages, [ .displayTitle, .displayLoading(isLading: true), .displayLoading(isLading: false), .displayPokemons ])
    }
    
    func test_viewLoaded_deliversErrorMessage() {
        let useCase = LoadPokemonsFromRemoteUseCase(remoteDataSource: MockErrorPokemonRemoteDataSource())
        let (sut, viewSpy) = makeSUT(useCase: useCase)
        
        sut.viewLoaded()
        
        XCTAssertEqual(viewSpy.messages, [ .displayTitle, .displayLoading(isLading: true), .displayLoading(isLading: false), .displayMessage ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(useCase: LoadPokemonsFromRemoteUseCase, file: StaticString = #filePath, line: UInt = #line) -> (sut: PokemonsPresenter, viewSpy: PokemonsViewSpy) {
        let viewSpy = PokemonsViewSpy()
        let sut = PokemonsPresenter(useCase: useCase)
        sut.view = viewSpy
        trackForMemoryLeak(on: sut, file: file, line: line)
        return (sut, viewSpy)
    }
    
    private class PokemonsViewSpy: PokemonsView {
        
        enum Message: Equatable {
            case displayTitle
            case displayPokemons
            case displayLoading(isLading: Bool)
            case displayMessage
        }
        
        private(set) var messages = [Message]()
        
        func display(_ viewModel: PokemonsNavigationBarViewModel) {
            messages.append(.displayTitle)
        }
        
        func display(_ viewModels: [PokemonCellViewModel]) {
            messages.append(.displayPokemons)
        }
        func display(_ viewModel: PokemonsLoadingViewModel) {
            messages.append(.displayLoading(isLading: viewModel.isLoading))
        }
        
        func display(_ viewModel: PokemonsErrorViewModel) {
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
