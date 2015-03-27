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

private enum StringResult: CustomResult {
    case Success(String)
    case Failure(NSError)
    
    init(_ success: String) {
        self = .Success(success)
    }
    
    init(failure: NSError) {
        self = .Failure(failure)
    }
    
    var isSuccess: Bool {
        switch self {
        case .Success: return true
        case .Failure: return false
        }
    }
    
    var value: String! {
        switch self {
        case .Success(let value): return value
        case .Failure: return nil
        }
    }
    
    var error: NSError? {
        switch self {
        case .Success: return nil
        case .Failure(let error): return error
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
    
    func testSuccessIsSuccess() {
        XCTAssertTrue(successResult.isSuccess)
    }
    
    func testFailureIsNotSuccess() {
        XCTAssertFalse(failureResult.isSuccess)
    }
    
    func testSuccessReturnsValue() {
        XCTAssertEqual(successResult.value, testValue)
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
        let y = flatMap(successResult, doubleSuccess)
        XCTAssert(y.value == testValue + testValue)
    }
    
    func testFlatMapSuccessFailure() {
        let y = flatMap(successResult, doubleFailure)
        XCTAssert(y.error == testError)
    }
    
    func testFlatMapFailureSuccess() {
        let y = flatMap(failureResult2, doubleSuccess)
        XCTAssert(y.error == testError2)
    }
    
    func testFlatMapFailureFailure() {
        let y = flatMap(failureResult2, doubleFailure)
        XCTAssert(y.error == testError2)
    }
    
    func testDescriptionSuccess() {
        let x: AnyResult<Int> = success(42)
        XCTAssertEqual(x.description, "Success: 42")
    }
    
    func testDescriptionFailure() {
        let x: AnyResult<String> = failure()
        XCTAssert(x.description.hasPrefix("Failure: Error Domain= Code=-1 "))
    }
    
    func testCoalesceSuccess() {
        let r: AnyResult<Int> = success(42)
        let x = r ?? 43
        XCTAssertEqual(x, 42)
    }
    
    func testCoalesceFailure() {
        let r: AnyResult<Int> = failure()
        let x = r ?? 43
        XCTAssertEqual(x, 43)
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

