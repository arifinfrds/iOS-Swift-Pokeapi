//
//  LoadPokemonsLocalFirstUseCase.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

final class LoadPokemonsLocalFirstUseCase: LoadPokemonsUseCase {
    
    private let localUseCase: LoadPokemonsUseCase
    private let remoteUseCase: LoadPokemonsUseCase
    
    init(localUseCase: LoadPokemonsUseCase, remoteUseCase: LoadPokemonsUseCase) {
        self.localUseCase = localUseCase
        self.remoteUseCase = remoteUseCase
    }
    
    func execute(completion: @escaping (LoadPokemonsFromRemoteUseCase.Result) -> Void) {
        executeLocalUseCase(onCompleted: { [weak self] localResult in
            completion(localResult)
            
            self?.executeRemoteUseCase(onCompleted: { remoteResult in
                completion(remoteResult)
            })
        })
    }
}

private extension LoadPokemonsLocalFirstUseCase {
    
    private func executeLocalUseCase(onCompleted: @escaping (LoadPokemonsFromRemoteUseCase.Result) -> Void) {
        localUseCase.execute { result in
            switch result {
            case .success(let response):
                onCompleted(.success(response))
            case .failure(let error):
                onCompleted(.failure(error))
            }
        }
    }
    
    private func executeRemoteUseCase(onCompleted: @escaping (LoadPokemonsFromRemoteUseCase.Result) -> Void) {
        remoteUseCase.execute { result in
            switch result {
            case .success(let response):
                onCompleted(.success(response))
            case .failure(let error):
                onCompleted(.failure(error))
            }
        }
    }
    
}
