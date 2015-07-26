//
//  OptionalTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import Lustre

class OptionalTests: XCTestCase {
    
    private let aValue = 42
    
    private let aSuccessResult = Either<Void, Int>(right: 42)
    private var aFailureResult =  Either<Void, Int>()
    
    func testEqualityOptional() {
        XCTAssert(aSuccessResult == Optional(right: aValue))
        XCTAssertFalse(aSuccessResult == Optional(left: ()))
        XCTAssert(aFailureResult == Optional(left: ()))
        XCTAssertFalse(aFailureResult == Optional(right: aValue))
    }
    
    func testInequalityOptional() {
        XCTAssert(Either(right: 42) != Optional(right: -aValue))
        XCTAssertFalse(Either<Void, Int>() != Optional(left: ()))
    }

}
