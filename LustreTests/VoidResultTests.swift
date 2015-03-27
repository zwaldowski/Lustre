//
//  VoidResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

class VoidResultTests: XCTestCase {
    
    let testError = error("This is a test.")
    let testError2 = error("Ce ne est pas un test.")
    
    private var successResult: VoidResult  { return success() }
    private var failureResult: VoidResult  { return failure(testError) }
    private var failureResult2: VoidResult { return failure(testError2) }

    func testSuccessIsSuccess() {
        XCTAssertTrue(successResult.isSuccess)
    }

    func testFailureIsNotSuccess() {
        XCTAssertFalse(failureResult.isSuccess)
    }

    func testSuccessReturnsNoError() {
        XCTAssertNil(successResult.error)
    }

    func testFailureReturnsError() {
        XCTAssert(failureResult.error == testError)
    }

    func testMapSuccessNewType() {
        let result = successResult.map { "Test" }
        XCTAssert(result.value == "Test")
    }

    func testMapFailureNewType() {
        let result = failureResult.map { return "Test" }
        XCTAssert(result.value == nil)
        XCTAssert(result.error == testError)
    }

    func doubleSuccess() -> AnyResult<Int> {
        return success(42)
    }

    func doubleFailure() -> AnyResult<Int> {
        return failure(testError)
    }

    func testFlatMapSuccessSuccess() {
        let y = successResult.flatMap(doubleSuccess)
        XCTAssert(y.value != nil)
    }

    func testFlatMapSuccessFailure() {
        let y = successResult.flatMap(doubleFailure)
        XCTAssert(y.error == testError)
    }

    func testFlatMapFailureSuccess() {
        let y = failureResult2.flatMap(doubleSuccess)
        XCTAssert(y.error == testError2)
    }

    func testFlatMapFailureFailure() {
        let y = failureResult2.flatMap(doubleFailure)
        XCTAssert(y.error == testError2)
    }

    func testDescriptionSuccess() {
        XCTAssertEqual(successResult.description, "Success: ()")
    }

    func testDescriptionFailure() {
        XCTAssert(failureResult.description.hasPrefix("Failure: Error Domain= Code=-1 "))
    }

    func testSuccessEquality() {
        XCTAssert(successResult == success())
    }

    func testFailureEquality() {
        XCTAssert(failureResult == failure(testError))
    }

    func testFailureInequality() {
        XCTAssert(failureResult != failureResult2)
    }
    
}
