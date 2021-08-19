//
//  PokemonsPresenter.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

struct PokemonsNavigationBarViewModel {
    let title: String
}

struct PokemonCellViewModel {
    let pokemon: Pokemon
    let subtitle: String
}

struct PokemonsLoadingViewModel {
    let isLoading: Bool
}

struct PokemonsErrorViewModel {
    let title: String
    let message: String
}

protocol PokemonsView {
    func display(_ viewModel: PokemonsNavigationBarViewModel)
    func display(_ cellViewModels: [PokemonCellViewModel])
    func display(_ viewModel: PokemonsLoadingViewModel)
    func display(_ viewModel: PokemonsErrorViewModel)
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
        view?.display(.init(title: "Pokemon"))
        view?.display(.init(isLoading: true))
        useCase.execute { [weak self] result in
            guard let self = self else { return }
            
            self.view?.display(.init(isLoading: false))
            
            switch result {
            case let .success(loadPokemonsResponse):
                let pokemons = loadPokemonsResponse.results ?? []
                let cellViewModels = pokemons.enumerated().map { (index, pokemon) in
                    PokemonCellViewModel(pokemon: pokemon, subtitle: "#0\(index)")
                }
                self.view?.display(cellViewModels)
            
            case let .failure(error):
                self.view?.display(.init(title: "Oops..", message: error.localizedDescription))
            }
        }
    }
}
