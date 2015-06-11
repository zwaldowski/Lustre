//
//  ErrorConversionTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre
import Foundation

class ErrorConversionTests: XCTestCase {
    
    private let testValue = 42
    private let testError = Error.First
    private let testError2 = Error.Second
    
    func testInitializeProducesObject() {
        let failureResult = failure(testError) as Result<Int, NSError>
        XCTAssert(failureResult.value == nil)
        guard let error = failureResult.error else { XCTFail(); return }
        XCTAssert(String(error).hasPrefix("Error Domain="))
    }
    
    func testErrorFlatMap() {
        let initialResult = failure(testError2) as Result<Int, Error>
        let mappedResult = initialResult.flatMap { success($0 * 2) } as Result<Int, NSError>
        
        XCTAssert(mappedResult.value == nil)
        guard let error = mappedResult.error else { XCTFail(); return }
        XCTAssert(String(error).hasPrefix("Error Domain="))
    }
    
}
