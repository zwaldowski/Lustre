//
//  AnyResultTests.swift
//  LustreTests
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import XCTest
import Lustre

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

class AnyResultTests: XCTestCase {
    
    let testValue = 42
    let testError = NSError(domain: "", code: 11, userInfo: nil)
    let testError2 = NSError(domain: "", code: 12, userInfo: nil)
    
    private var successResult: AnyResult<Int>  { return success(testValue) }
    private var failureResult: AnyResult<Int>  { return failure(testError) }
    private var failureResult2: AnyResult<Int> { return failure(testError2) }

    func testSuccessIsSuccess() {
        XCTAssertTrue(successResult.isSuccess)
    }

    func testFailureIsNotSuccess() {
        XCTAssertFalse(failureResult.isSuccess)
    }

    func testSuccessReturnsValue() {
        XCTAssert(successResult.value == 42)
    }

    func testSuccessReturnsNoError() {
        XCTAssertNil(successResult.error)
    }

    func testFailureReturnsError() {
        XCTAssert(failureResult.error == testError)
    }

    func testMapSuccessUnaryOperator() {
        XCTAssert(successResult.map(-).value == -42)
    }

    func testMapFailureUnaryOperator() {
        let y = failureResult.map(-)
        XCTAssert(y.value == nil)
        XCTAssert(y.error == testError)
    }

    func testMapSuccessNewType() {
        let x = success("abcd")
        let y = x.map(count)
        XCTAssert(y.value == 4)
    }

    func testMapFailureNewType() {
        let x: AnyResult<String> = failure(testError)
        let y = x.map(count)
        XCTAssert(y.error == testError)
    }

    func doubleSuccess(x: Int) -> AnyResult<Int> {
        return success(x * 2)
    }

    func doubleFailure(x: Int) -> AnyResult<Int> {
        return failure(testError)
    }

    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        let y = flatMap(successResult, doubleSuccess)
        XCTAssert(x.value == 84)
        XCTAssert(y.value == 84)
    }

    func testFlatMapSuccessFailure() {
        let x = successResult.flatMap(doubleFailure)
        let y = flatMap(successResult, doubleFailure)
        XCTAssert(x.error == testError)
        XCTAssert(y.error == testError)
    }

    func testFlatMapFailureSuccess() {
        let x = failureResult2.flatMap(doubleSuccess)
        let y = flatMap(failureResult2, doubleSuccess)
        XCTAssert(x.error == testError2)
        XCTAssert(y.error == testError2)
    }

    func testFlatMapFailureFailure() {
        let x = failureResult2.flatMap(doubleFailure)
        let y = flatMap(failureResult2, doubleFailure)
        XCTAssert(x.error == testError2)
        XCTAssert(y.error == testError2)
    }

    func testDescriptionSuccess() {
        XCTAssertEqual(successResult.description, "Success: 42")
    }

    func testDescriptionFailure() {
        XCTAssert(failureResult.description.hasPrefix("Failure: Error Domain= Code=11 "))
    }

    func testCoalesceSuccess() {
        XCTAssertEqual(successResult ?? 43, 42)
    }

    func testCoalesceFailure() {
        XCTAssertEqual(failureResult ?? 43, 43)
    }

    private func makeTryFunction<T>(x: T, _ succeed: Bool = true)(error: NSErrorPointer) -> T? {
        if !succeed {
            error.memory = NSError(domain: "domain", code: 1, userInfo: [:])
            return nil
        }
        return x
    }

    func testTryTSuccess() {
        XCTAssertEqual(try(makeTryFunction(testValue)) ?? 43, testValue)
    }

    func testTryTFailure() {
        let result = try(makeTryFunction(testValue, false))
        XCTAssertEqual(result ?? 43, 43)
        XCTAssert(result.description.hasPrefix("Failure: Error Domain=domain Code=1 "))
    }

    func testTryBoolSuccess() {
        XCTAssert(try(makeTryFunction(true)).isSuccess)
    }

    func testTryBoolFailure() {
        let result = try(makeTryFunction(false, false))
        XCTAssertFalse(result.isSuccess)
        XCTAssert(result.description.hasPrefix("Failure: Error Domain=domain Code=1 "))
    }

    func testSuccessEquality() {
        XCTAssert(successResult == success(testValue))
    }

    func testFailureEquality() {
        XCTAssert(failureResult == failure(testError))
    }

    func testSuccessInequality() {
        XCTAssert(successResult != success(49))
    }

    func testFailureInequality() {
        XCTAssert(failureResult != failureResult2)
    }
    
    func testVoidSwitchFailure() {
        switch failureResult {
        case .Success: XCTFail("Not a success case")
        case .Failure(let err): break
        }
    }
    
}
