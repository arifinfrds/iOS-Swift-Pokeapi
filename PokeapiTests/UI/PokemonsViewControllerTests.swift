//
//  PokemonsViewControllerTests.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 19/08/21.
//

import XCTest
@testable import Pokeapi

class PokemonsViewControllerTests: XCTestCase {
    
    func test_instantiateViewController_isPokemonsViewController() {
        let identifier = "PokemonsViewController"
        let storyboard = UIStoryboard(name: identifier, bundle: .main)
        
        let viewController = storyboard.instantiateViewController(identifier: identifier)
        
        XCTAssertTrue(viewController is PokemonsViewController)
    }
    
}
