//
//  LoadPokemonResponse.swift
//  Pokeapi
//
//  Created by Arifin Firdaus on 18/08/21.
//

import Foundation

struct LoadPokemonResponse: Codable {
    let count: Int?
    let next: String?
    let results: [Pokemon]?
    
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case next = "next"
        case results = "results"
    }
}
