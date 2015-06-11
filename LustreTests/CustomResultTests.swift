//
//  CustomResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

private enum StringResult: ResultType {
    case Success(String)
    case Failure(Error)
    
    init(_ success: String) {
        self = .Success(success)
    }
    
    init(failure: Error) {
        self = .Failure(failure)
    }
    
    func analysis<R>(@noescape ifSuccess ifSuccess: String -> R, @noescape ifFailure: Error -> R) -> R {
        switch self {
        case .Success(let string): return ifSuccess(string)
        case .Failure(let error): return ifFailure(error)
        }
    }

}

class CustomResultTests: XCTestCase {
    
    let testValue = "Result"
    let testError = Error.First
    let testError2 = Error.Second
    
    private var successResult: StringResult  { return success(testValue) }
    private var failureResult: StringResult  { return failure(testError) }
    private var failureResult2: StringResult { return failure(testError2) }
    
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
    
    func testFailureReturnsNoValue() {
        XCTAssert(failureResult.value == nil)
    }
    
    func testMapSuccessNewType() {
        XCTAssert(successResult.map { $0.characters.count }.value == testValue.characters.count)
    }

    func testMapFailureNewType() {
        XCTAssert(failureResult.map { $0.characters.count }.error == testError)
    }
    
    private func doubleSuccess(x: String) -> StringResult {
        return success(x + x)
    }
    
    private func doubleFailure(x: String) -> StringResult {
        return failure(testError)
    }
    
    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        XCTAssert(x.value == testValue + testValue)
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
    
    func testCoalesceSuccess() {
        let result = StringResult("42")
        XCTAssertEqual(result ?? "43", "42")
    }
    
    func testCoalesceFailure() {
        let result = StringResult(failure: Error.Second)
        XCTAssertEqual(result ?? "43", "43")
    }
    
    func testEqualityDifferentTypes() {
        XCTAssert(successResult == Result<String, Error>(testValue))
        XCTAssertFalse(successResult == Result<String, Error>(failure: testError))
        XCTAssert(failureResult == Result<String, Error>(failure: testError))
        XCTAssertFalse(failureResult == Result<String, Error>(testValue))
    }
    
    func testInequalityDifferentTypes() {
        XCTAssert(successResult != Result<String, Error>("Different Result"))
        XCTAssert(failureResult != Result<String, Error>(failure: testError2))
    }
    
}
