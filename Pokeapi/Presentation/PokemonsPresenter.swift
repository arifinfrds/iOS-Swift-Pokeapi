//
//  PokemonsPresenter.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

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
    var view: PokemonsView?
    
    init(useCase: LoadPokemonsUseCase) {
        self.useCase = useCase
    }
    
    func viewLoaded() {
        view?.display(true)
        useCase.execute { [weak self] result in
            guard let self = self else { return }
            
            self.view?.display(false)
            
            switch result {
            case let .success(loadPokemonsResponse):
                self.view?.display(loadPokemonsResponse.results ?? [])
            case let .failure(error):
                self.view?.display(error.localizedDescription)
            }
        }
    }
}
