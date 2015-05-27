//
//  CustomResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

private enum StringResult: ResultType {
    case Success(String)
    case Failure(NSError)
    
    init(_ success: String) {
        self = .Success(success)
    }
    
    init(failure: NSError) {
        self = .Failure(failure)
    }
    
    var value: String? {
        return valueOf(self)
    }
    
    var error: NSError? {
        return errorOf(self)
    }
    
    var description: String {
        return descriptionOf(self)
    }
    
    func flatMap<Result: ResultType>(@noescape transform: String -> Result) -> Result {
        return Lustre.flatMap(self, transform)
    }

    func map<Result: ResultType>(@noescape transform: String -> Result.Value) -> Result {
        return Lustre.map(self, transform)
    }
    
    func analysis<R>(@noescape #ifSuccess: String -> R, @noescape ifFailure: NSError -> R) -> R {
        switch self {
        case .Success(let string): return ifSuccess(string)
        case .Failure(let error): return ifFailure(error)
        }
    }

}

class CustomResultTests: XCTestCase {
    
    let testValue = "Result"
    let testError = error("This is a test.")
    let testError2 = error("Ce ne est pas un test.")
    
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
        XCTAssertNil(successResult.error)
    }
    
    func testFailureReturnsError() {
        XCTAssert(failureResult.error == testError)
    }
    
    func testFailureReturnsNoValue() {
        XCTAssertNil(failureResult.value)
    }
    
    func testMapSuccessNewType() {
        XCTAssert(map(successResult, count).value == count(testValue))
    }
    
    func testMapFailureNewType() {
        XCTAssert(map(failureResult, count).error == testError)
    }
    
    private func doubleSuccess(x: String) -> StringResult {
        return success(x + x)
    }
    
    private func doubleFailure(x: String) -> StringResult {
        return failure(testError)
    }
    
    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        let y = successResult >>== doubleSuccess
        XCTAssert(x.value == testValue + testValue)
        XCTAssert(y.value == testValue + testValue)
    }
    
    func testFlatMapSuccessFailure() {
        let x = successResult.flatMap(doubleFailure)
        let y = successResult >>== doubleFailure
        XCTAssert(x.error == testError)
        XCTAssert(y.error == testError)
    }
    
    func testFlatMapFailureSuccess() {
        let x = failureResult2.flatMap(doubleSuccess)
        let y = failureResult2 >>== doubleSuccess
        XCTAssert(x.error == testError2)
        XCTAssert(y.error == testError2)
    }
    
    func testFlatMapFailureFailure() {
        let x = failureResult2.flatMap(doubleFailure)
        let y = failureResult2 >>== doubleFailure
        XCTAssert(x.error == testError2)
        XCTAssert(y.error == testError2)
    }
    
    func testCoalesceSuccess() {
        let r: StringResult = success("42")
        let x = r ?? "43"
        XCTAssertEqual(x, "42")
    }
    
    func testCoalesceFailure() {
        let r: StringResult = failure()
        let x = r ?? "43"
        XCTAssertEqual(x, "43")
    }
    
    func testSuccessEquality() {
        XCTAssert(successResult == success(testValue))
    }
    
    func testFailureEquality() {
        XCTAssert(failureResult == failure(testError))
    }
    
    func testSuccessInequality() {
        XCTAssert(successResult != success("Different Result"))
    }
    
    func testFailureInequality() {
        XCTAssert(failureResult != failureResult2)
    }
    
}

