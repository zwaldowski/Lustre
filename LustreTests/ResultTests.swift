//
//  ResultTests.swift
//  LustreTests
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import Lustre

class ResultTests: XCTestCase {
    
    let aTestValue = 42
    let aTestError1 = Error.First
    let aTestError2 = Error.Second
    
    private var aSuccessResult  = Result<Int>(value: 42)
    private var aFailureResult1 = Result<Int>(error: Error.First)
    private var aFailureResult2 = Result<Int>(error: Error.Second)
    
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
        XCTAssert(String(aFailureResult1).hasSuffix("Error.First"))
        XCTAssert(String(aFailureResult2).hasSuffix("Error.Second"))
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssertEqual(String(reflecting: aSuccessResult), "Success(\(String(reflecting: aTestValue)))")
    }
    
    func testDebugDescriptionFailure() {
        let debugDescription1 = String(reflecting: aFailureResult1)
        XCTAssert(debugDescription1.hasPrefix("Failure("))
        XCTAssert(debugDescription1.hasSuffix("Error.First)"))
    }
    
    func testSuccessGetter() {
        XCTAssert(aSuccessResult.isSuccess)
        XCTAssertFalse(aFailureResult1.isSuccess)
        XCTAssertFalse(aFailureResult2.isSuccess)
    }
    
    func testFailureGetter() {
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
    
    func testInitFailWithSuccess() {
        let result: Result<Int> = Result(aTestValue, failWith: aTestError1)
        assertSuccess(result, aTestValue)
    }
    
    func testInitFailWith() {
        let result: Result<Int> = Result(nil, failWith: aTestError1)
        assertFailure(result, aTestError1)
    }
    
    func testThrowingInitSuccess() {
        func doAction() throws -> Int {
            return aTestValue
        }
        
        assertSuccess(Result(doAction), aTestValue)
    }
    
    func testThrowingInitFailure() {
        func doAction() throws -> Int {
            throw aTestError1
        }
        
        assertFailure(Result(doAction), aTestError1)
    }
    
    func testCoalesceSuccess() {
        XCTAssertEqual(aSuccessResult ?? 43, 42)
        XCTAssertEqual(aSuccessResult.recover(43), 42)
    }
    
    func testCoalesceFailure() {
        XCTAssertEqual(aFailureResult1 ?? 43, 43)
        XCTAssertEqual(aFailureResult1.recover(43), 43)
    }
    
    func testFlatCoalesceSuccess() {
        assertSuccess(aSuccessResult.recoverWith(Result(value: aTestValue * 2)), aTestValue)
        assertSuccess(aSuccessResult ?? Result(value: aTestValue * 2), aTestValue)
    }
    
    func testFlatCoalesceFailure() {
        assertSuccess(aFailureResult1.recoverWith(Result(value: aTestValue * 2)), aTestValue * 2)
        assertSuccess(aFailureResult1 ?? Result(value: aTestValue * 2), aTestValue * 2)
    }
    
    func testAnyEquals() {
        typealias Tuple = (Int, String)
        let tupleSuccess1: Result<Tuple> = Result(value: (42, "test"))
        let tupleFailure1: Result<Tuple> = Result(error: Error.First)
        let tupleFailure2: Result<Tuple> = Result(error: Error.Second)
        
        func tuplesEqual(lhs: Tuple, rhs: Tuple) -> Bool {
            return lhs.0 == rhs.0 && lhs.1 == rhs.1
        }
        
        func errorsEqual(lhs: ErrorType, rhs: ErrorType) -> Bool {
            return lhs.matches(rhs)
        }
        
        // same case, same value
        XCTAssertTrue(tupleSuccess1.equals(tupleSuccess1, leftEqual: errorsEqual, rightEqual: tuplesEqual))
        XCTAssertTrue(tupleFailure1.equals(tupleFailure1, leftEqual: errorsEqual, rightEqual: tuplesEqual))
        
        // same case, different value
        XCTAssertFalse(tupleFailure1.equals(tupleFailure2, leftEqual: errorsEqual, rightEqual: tuplesEqual))
        
        // different case
        XCTAssertFalse(tupleSuccess1.equals(tupleFailure2, leftEqual: errorsEqual, rightEqual: tuplesEqual))
        XCTAssertFalse(tupleSuccess1.equals(tupleFailure1, leftEqual: errorsEqual, rightEqual: tuplesEqual))
        XCTAssertFalse(tupleFailure1.equals(tupleSuccess1, leftEqual: errorsEqual, rightEqual: tuplesEqual))
    }
    
    func testEquality() {
        XCTAssert(aSuccessResult == aSuccessResult)
        XCTAssert(aSuccessResult == Result(value: aTestValue))
        XCTAssertFalse(aSuccessResult == aFailureResult1)
        XCTAssert(aFailureResult1 == aFailureResult1)
        XCTAssert(aFailureResult1 == Result(error: aTestError1))
        XCTAssertFalse(aFailureResult1 == aSuccessResult)
    }
    
    func testInequality() {
        XCTAssert(aSuccessResult != aFailureResult1)
        XCTAssert(aFailureResult1 != aSuccessResult)
        XCTAssert(aSuccessResult != Result(value: aTestValue * 2))
        XCTAssert(aFailureResult1 != aFailureResult2)
    }

    func testMapSuccessUnaryOperator() {
        let x = aSuccessResult.map(-)
        assertSuccess(x, aTestValue * -1)
    }

    func testMapFailureUnaryOperator() {
        let x = aFailureResult1.map(-)
        assertFailure(x, Error.First)
    }
    
    private func countCharacters(string: String) -> Int {
        return string.characters.count
    }

    func testMapSuccessNewType() {
        let x = Result<String>(value: "abcd")
        let y = x.map(countCharacters)
        assertSuccess(y, 4)
    }

    func testMapFailureNewType() {
        let x = Result<String>(error: aTestError1)
        let y = x.map(countCharacters)
        assertFailure(y, aTestError1)
    }

    func doubleSuccess(x: Int) -> Result<Int> {
        return Result(value: x * 2)
    }

    func doubleFailure(x: Int) -> Result<Int> {
        return Result(error: aTestError2)
    }

    func testFlatMapSuccessSuccess() {
        let x = aSuccessResult.flatMap(doubleSuccess)
        assertSuccess(x, 84)
    }

    func testFlatMapSuccessFailure() {
        let x = aSuccessResult.flatMap(doubleFailure)
        assertFailure(x, aTestError2)
    }

    func testFlatMapFailureSuccess() {
        let x = aFailureResult1.flatMap(doubleSuccess)
        assertFailure(x, aTestError1)
    }

    func testFlatMapFailureFailure() {
        let x = aFailureResult1.flatMap(doubleFailure)
        assertFailure(x, aTestError1)
    }
    
}
