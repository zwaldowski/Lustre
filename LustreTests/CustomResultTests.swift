//
//  CustomResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/26/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import Lustre

private enum StringResult: EitherType {
    case Failure(ErrorType)
    case Success(String)
    
    init(right success: String) {
        self = .Success(success)
    }
    
    init(left failure: ErrorType) {
        self = .Failure(failure)
    }
    
    func analysis<Result>(@noescape ifLeft ifLeft: ErrorType -> Result, @noescape ifRight: String -> Result) -> Result {
        switch self {
        case .Failure(let error): return ifLeft(error)
        case .Success(let string): return ifRight(string)
        }
    }

}

class CustomResultTests: XCTestCase {
    
    let aTestValue  = "Result"
    let aTestError1 = Error.First
    let aTestError2 = Error.Second
    
    private let aSuccessResult  = StringResult.Success("Result")
    private let aFailureResult1 = StringResult.Failure(Error.First)
    private let aFailureResult2 = StringResult.Failure(Error.Second)
    
    func testSuccessExtract() {
        assertNoThrow(aSuccessResult.extract, aTestValue)
    }
    
    func testFailureExtract() {
        assertThrows(aFailureResult1.extract, Error.First)
        assertThrows(aFailureResult2.extract, Error.Second)
    }
    
    func testDescriptionSuccess() {
        XCTAssertEqual(String(aSuccessResult), String(aTestValue))
    }
    
    func testDescriptionFailure() {
        XCTAssertEqual(String(aFailureResult1), "First")
        XCTAssertEqual(String(aFailureResult2), "Second")
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssertEqual(String(reflecting: aSuccessResult), "Right(\(String(reflecting: aTestValue)))")
    }
    
    func testDebugDescriptionFailure() {
        let debugDescription1 = String(reflecting: aFailureResult1)
        XCTAssert(debugDescription1.hasPrefix("Left("))
        XCTAssert(debugDescription1.hasSuffix("Error.First)"))
    }
    
    func testIsSuccessGetter() {
        XCTAssert(aSuccessResult.isSuccess)
        XCTAssertFalse(aFailureResult1.isSuccess)
        XCTAssertFalse(aFailureResult2.isSuccess)
    }
    
    func testIsFailureGetter() {
        XCTAssertFalse(aSuccessResult.isFailure)
        XCTAssert(aFailureResult1.isFailure)
        XCTAssert(aFailureResult2.isFailure)
    }
    
    func testSuccessReturnsValue() {
        XCTAssert(aSuccessResult.value == aTestValue)
    }
    
    func testSuccessReturnsNoError() {
        XCTAssert(aSuccessResult.error == nil)
    }
    
    func testFailureReturnsError() {
        assertErrorMatches(aFailureResult1.error!, aTestError1)
    }
    
    func testFailureReturnsNoValue() {
        XCTAssert(aFailureResult1.value == nil)
    }
    
    func testCoalesceSuccess() {
        let result = StringResult(right: "42")
        XCTAssertEqual(result ?? "43", "42")
    }
    
    func testCoalesceFailure() {
        let result = StringResult(left: Error.Second)
        XCTAssertEqual(result ?? "43", "43")
    }
    
    func testEqualityDifferentTypes() {
        XCTAssert(aSuccessResult == Result<String>(value: aTestValue))
        XCTAssertFalse(aSuccessResult == Result<String>(error: aTestError1))
        XCTAssert(aFailureResult1 == Result<String>(error: aTestError1))
        XCTAssertFalse(aFailureResult1 == Result<String>(value: aTestValue))
    }
    
    func testInequalityDifferentTypes() {
        XCTAssert(aSuccessResult != Result<String>(value: "Different Result"))
        XCTAssert(aFailureResult1 != Result<String>(error: aTestError2))
    }
    
    private func countCharacters(string: String) -> Int {
        return string.characters.count
    }
    
    func testMapSuccessNewType() {
        assertSuccess(aSuccessResult.map(countCharacters), aTestValue.characters.count)
    }

    func testMapFailureNewType() {
        assertFailure(aFailureResult1.map(countCharacters), aTestError1)
    }
    
    private func doubleSuccess(x: String) -> Result<String> {
        return .Success(x + x)
    }
    
    private func doubleFailure(x: String) -> Result<String> {
        return .Failure(aTestError1)
    }
    
    func testFlatMapSuccessSuccess() {
        let result = aSuccessResult.flatMap(doubleSuccess)
        assertSuccess(result, aTestValue + aTestValue)
    }
    
    func testFlatMapSuccessFailure() {
        let result = aSuccessResult.flatMap(doubleFailure)
        assertFailure(result, aTestError1)
    }
    
    func testFlatMapFailureSuccess() {
        let result = aFailureResult2.flatMap(doubleSuccess)
        assertFailure(result, aTestError2)
    }
    
    func testFlatMapFailureFailure() {
        let result = aFailureResult2.flatMap(doubleFailure)
        assertFailure(result, aTestError2)
    }
    
}
