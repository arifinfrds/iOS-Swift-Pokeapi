//
//  DelayedLoadPokemonsUseCase.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class DelayedLoadPokemonsUseCase: LoadPokemonsUseCase {
    
    private let useCase: LoadPokemonsUseCase
    
    init(useCase: LoadPokemonsUseCase) {
        self.useCase = useCase
    }
    
    func execute(completion: @escaping (LoadPokemonsUseCase.Result) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.useCase.execute(completion: completion)
        }
    }
}

