//
//  CacheClient.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

protocol CacheClient {
    func save(_ data: Data, forKey key: String)
    func load(key: String) -> Data?
}

final class UserDefaultCacheClient: CacheClient {
    
    let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func save(_ data: Data, forKey key: String) {
        defaults.set(data, forKey: key)
    }
    
    func load(key: String) -> Data? {
        defaults.data(forKey: key)
    }
    
}
