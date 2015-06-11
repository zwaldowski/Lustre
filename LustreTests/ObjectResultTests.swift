//
//  ObjectResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

class ObjectResultTests: XCTestCase {
    
    private let testValue = NSObject()
    private let testError = Error.First
    private let testError2 = Error.Second
    
    private var successResult: Result<NSObject, Error>  { return success(testValue) }
    private var failureResult: Result<NSObject, Error>  { return failure(testError) }
    private var failureResult2: Result<NSObject, Error> { return failure(testError2) }

    func testSuccessAnalysis() {
        successResult.analysis(ifSuccess: { _ in }, ifFailure: {
            XCTFail("Expected success, found \($0)")
        })
    }

    func testFailureAnalysis() {
        failureResult.analysis(ifSuccess: {
            XCTFail("Expected failure, found \($0)")
        }, ifFailure: { _ in })
    }

    func testSuccessReturnsValue() {
        XCTAssert(successResult.value == testValue)
    }

    func testSuccessReturnsNoError() {
        XCTAssert(successResult.error == nil)
    }

    func testFailureReturnsError() {
        XCTAssert(failureResult.error == testError)
    }

    private func doubleSuccess(x: NSObject) -> Result<NSString, Error> {
        return success(x.description)
    }

    private func doubleFailure(x: NSObject) -> Result<NSString, Error> {
        return failure(testError)
    }

    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        XCTAssert(x.value != nil)
        XCTAssert(x.value !== testValue)
    }

    func testFlatMapSuccessFailure() {
        let x = successResult.flatMap(doubleFailure)
        XCTAssert(x.error == testError)
    }

    func testFlatMapFailureSuccess() {
        let x = failureResult2.flatMap(doubleSuccess)
        XCTAssert(x.error == testError2)
    }

    func testFlatMapFailureFailure() {
        let x = failureResult2.flatMap(doubleFailure)
        XCTAssert(x.error == testError2)
    }
    
    func testDescriptionSuccess() {
        XCTAssert(successResult.description.hasPrefix("<NSObject: "))
    }
    
    func testDescriptionFailure() {
        XCTAssertEqual(String(failureResult), "LustreTests.Error.First")
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssert(String(reflecting: successResult).hasPrefix("Success: <NSObject:"))
    }
    
    func testDebugDescriptionFailure() {
        XCTAssertEqual(String(reflecting: failureResult), "Failure: LustreTests.Error.First")
    }

    func testCoalesceSuccess() {
        XCTAssertEqual(successResult ?? NSNull(), testValue)
    }

    func testCoalesceFailure() {
        XCTAssertEqual(failureResult ?? NSNull(), NSNull())
    }

    func testSuccessEquality() {
        XCTAssert(successResult == success(testValue))
    }

    func testFailureEquality() {
        XCTAssert(failureResult == failure(testError))
    }

    func testSuccessInequality() {
        XCTAssert(successResult != success(NSObject()))
    }

    func testFailureInequality() {
        XCTAssert(failureResult != failureResult2)
    }
    
}
