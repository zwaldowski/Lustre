//
//  AnyResultTests.swift
//  LustreTests
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import XCTest
import Lustre

class AnyResultTests: XCTestCase {
    
    let testValue = 42
    let testError = Error.First
    let testError2 = Error.Second
    
    private var successResult: Result<Int, Error>  { return success(testValue) }
    private var failureResult: Result<Int, Error>  { return failure(testError) }
    private var failureResult2: Result<Int, Error> { return failure(testError2) }

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
        XCTAssert(successResult.value == 42)
    }

    func testSuccessReturnsNoError() {
        XCTAssert(successResult.error == nil)
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
        let x = success("abcd") as Result<String, Error>
        let y = x.map { $0.characters.count }
        XCTAssert(y.value == 4)
    }

    func testMapFailureNewType() {
        let x = failure(testError) as  Result<String, Error>
        let y = x.map { $0.characters.count }
        XCTAssert(y.error == testError)
    }

    func doubleSuccess(x: Int) -> Result<Int, Error> {
        return success(x * 2)
    }

    func doubleFailure(x: Int) -> Result<Int, Error> {
        return failure(testError)
    }

    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        XCTAssert(x.value == 84)
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
        XCTAssertEqual(String(successResult), "42")
    }
    
    func testDescriptionFailure() {
        XCTAssertEqual(String(failureResult), "LustreTests.Error.First")
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssertEqual(String(reflecting: successResult), "Success: 42")
    }
    
    func testDebugDescriptionFailure() {
        XCTAssertEqual(String(reflecting: failureResult), "Failure: LustreTests.Error.First")
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
    
}
