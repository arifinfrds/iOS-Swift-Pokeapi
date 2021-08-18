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
