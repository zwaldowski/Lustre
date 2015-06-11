//
//  VoidResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

class VoidResultTests: XCTestCase {
    
    private let testError = Error.First
    private let testError2 = Error.Second
    
    private var successResult: Result<Void, Error>  { return success() }
    private var failureResult: Result<Void, Error>  { return failure(testError) }
    private var failureResult2: Result<Void, Error> { return failure(testError2) }

    func testSuccessAnalysis() {
        successResult.analysis(ifSuccess: { }, ifFailure: {
            XCTFail("Expected success, found \($0)")
        })
    }

    func testFailureAnalysis() {
        failureResult.analysis(ifSuccess: {
            XCTFail("Expected failure")
        }, ifFailure: { _ in })
    }
    
    func testSuccessReturnsNoError() {
        XCTAssert(successResult.error == nil)
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

    private func doubleSuccess() -> Result<Int, Error> {
        return success(42)
    }

    private func doubleFailure() -> Result<Int, Error> {
        return failure(testError)
    }

    func testFlatMapSuccessSuccess() {
        let x = successResult.flatMap(doubleSuccess)
        XCTAssert(x.value != nil)
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
        XCTAssertEqual(String(successResult), "()")
    }
    
    func testDescriptionFailure() {
        XCTAssertEqual(String(failureResult), "LustreTests.Error.First")
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssertEqual(String(reflecting: successResult), "Success: ()")
    }
    
    func testDebugDescriptionFailure() {
        XCTAssertEqual(String(reflecting: failureResult), "Failure: LustreTests.Error.First")
    }
    
    func testEqualitySameType() {
        XCTAssert(successResult == successResult)
        XCTAssert(successResult == success())
        XCTAssertFalse(successResult == failureResult)
        XCTAssert(failureResult == failureResult)
        XCTAssert(failureResult == failure(testError))
        XCTAssertFalse(failureResult == successResult)
    }
    
    func testInequalitySameType() {
        XCTAssert(successResult != failureResult)
        XCTAssert(failureResult != successResult)
        XCTAssert(failureResult != failureResult2)
    }
    
    private enum ContrivedVoidResult: ResultType {
        case Success
        case Failure(Error)
        
        init(_ value: ()) {
            self = .Success
        }
        
        init(failure: Error) {
            self = .Failure(failure)
        }
        
        func analysis<R>(@noescape ifSuccess ifSuccess: () -> R, @noescape ifFailure: Error -> R) -> R {
            switch self {
            case .Success: return ifSuccess()
            case .Failure(let error): return ifFailure(error)
            }
        }
        
    }
    
    func testEqualityDifferentTypes() {
        XCTAssert(successResult == ContrivedVoidResult())
        XCTAssertFalse(successResult == ContrivedVoidResult(failure: testError))
        XCTAssert(failureResult == ContrivedVoidResult(failure: testError))
        XCTAssertFalse(failureResult == ContrivedVoidResult())
    }
    
    func testInequalityDifferentTypes() {
        XCTAssertFalse(successResult != ContrivedVoidResult())
        XCTAssert(failureResult != ContrivedVoidResult(failure: testError2))
    }
    
}
