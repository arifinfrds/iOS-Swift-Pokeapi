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
        let viewController = makeSUT()
        
        XCTAssertTrue(viewController is PokemonsViewController)
    }
    
    func test_outlets_isNotNil() {
        let viewController = makeSUT() as! PokemonsViewController
        
        viewController.loadViewIfNeeded()
        
        XCTAssertNotNil(viewController.tableView)
        XCTAssertNotNil(viewController.loadingContainerView)
        XCTAssertNotNil(viewController.activityIndicatorView)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> UIViewController {
        let identifier = "PokemonsViewController"
        let storyboard = UIStoryboard(name: identifier, bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: identifier)
        trackForMemoryLeak(on: viewController as! PokemonsViewController, file: file, line: line)
        return viewController
    }
    
}
