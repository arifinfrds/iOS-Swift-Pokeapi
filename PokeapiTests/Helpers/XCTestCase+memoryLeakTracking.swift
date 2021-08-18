//
//  XCTestCase+memoryLeakTracking.swift
//  PokeapiTests
//
//  Created by Arifin Firdaus on 18/08/21.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeak(on instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leaks.", file: file, line: line)
        }
    }
}

