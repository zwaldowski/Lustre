//
//  OptionalTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

class OptionalTests: XCTestCase {
    
    private let testValue = 42
    
    private var successResult: Result<Int, NoError>  { return success(testValue) }
    private var failureResult: Result<Int, NoError>  { return failure() }
    
    func testEqualityOptional() {
        XCTAssert(successResult == Optional(testValue))
        XCTAssertFalse(successResult == Optional(failure: .Unit))
        XCTAssert(failureResult == Optional(failure: .Unit))
        XCTAssertFalse(failureResult == Optional(testValue))
    }
    
    func testInequalityOptional() {
        XCTAssert(success(testValue) != Optional(-testValue))
        XCTAssertFalse(failure() != Optional(failure: .Unit))
    }

}
