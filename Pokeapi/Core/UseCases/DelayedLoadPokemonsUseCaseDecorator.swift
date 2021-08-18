//
//  DelayedLoadPokemonsUseCaseDecorator.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class DelayedLoadPokemonsUseCaseDecorator: LoadPokemonsUseCase {
    
    private let decoratee: LoadPokemonsUseCase
    
    init(useCase: LoadPokemonsUseCase) {
        self.decoratee = useCase
    }
    
    func execute(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.decoratee.execute(completion: completion)
        }
    }
}

