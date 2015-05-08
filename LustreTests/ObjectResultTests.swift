//
//  ObjectResultTests.swift
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

class ObjectResultTests: XCTestCase {
    
    let testValue = NSObject()
    let testError = error("This is a test.")
    let testError2 = error("Ce ne est pas un test.")
    
    private var successResult: ObjectResult<NSObject>  { return success(testValue) }
    private var failureResult: ObjectResult<NSObject>  { return failure(testError) }
    private var failureResult2: ObjectResult<NSObject> { return failure(testError2) }

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

    func doubleSuccess(x: NSObject) -> ObjectResult<NSString> {
        return success(x.description)
    }

    func doubleFailure(x: NSObject) -> ObjectResult<NSString> {
        return failure(testError)
    }

    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        let y = successResult >>== doubleSuccess
        XCTAssert(x.value != nil)
        XCTAssert(x.value !== testValue)
        XCTAssert(y.value != nil)
        XCTAssert(y.value !== testValue)
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

    func testDescriptionSuccess() {
        XCTAssert(successResult.description.hasPrefix("Success: <NSObject: "))
    }

    func testDescriptionFailure() {
        XCTAssert(failureResult.description.hasPrefix("Failure: Error Domain=\(ResultErrorDomain) Code=-1 "))
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
