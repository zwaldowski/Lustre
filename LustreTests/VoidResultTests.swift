//
//  VoidResultTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/27/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import Lustre

class VoidResultTests: XCTestCase {
    
    fileprivate let anError1        = Error.first
    fileprivate let anError2        = Error.second
    fileprivate let aSuccessResult1 = Result<Void>()
    fileprivate let aFailureResult1 = Result<Void>(error: Error.first)
    fileprivate let aSuccessResult2 = ContrivedVoidResult()
    fileprivate let aFailureResult2 = ContrivedVoidResult(left: Error.second)
    
    fileprivate enum ContrivedVoidResult: EitherType {
        case failure(Swift.Error)
        case success
        
        init(left: Swift.Error) {
            self = .failure(left)
        }
        
        init(right: ()) {
            self = .success
        }
        
        func analysis<Result>(ifLeft: (Swift.Error) -> Result, ifRight: (Void) -> Result) -> Result {
            switch self {
            case .failure(let error): return ifLeft(error)
            case .success: return ifRight()
            }
        }
        
    }
    
    func testSuccessExtract() {
        assertNoThrow(void: aSuccessResult1.extract)
        assertNoThrow(void: aSuccessResult2.extract)
    }
    
    func testFailureExtract() {
        assertThrows(aFailureResult1.extract, Error.first)
        assertThrows(aFailureResult2.extract, Error.second)
    }
    
    func testDescriptionSuccess() {
        XCTAssertEqual(String(describing: aSuccessResult1), "()")
        XCTAssertEqual(String(describing: aSuccessResult2), "()")
    }
    
    func testDescriptionFailure() {
        XCTAssertEqual(String(describing: aFailureResult1), "first")
        XCTAssertEqual(String(describing: aFailureResult2), "second")
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssert(String(reflecting: aSuccessResult1) == "Success(())")
        XCTAssert(String(reflecting: aSuccessResult2) == "Right(())")
    }
    
    func testDebugDescriptionFailure() {
        let debugDescription1 = String(reflecting: aFailureResult1)
        XCTAssert(debugDescription1.hasPrefix("Failure("))
        XCTAssert(debugDescription1.hasSuffix("Error.first)"))
        
        let debugDescription2 = String(reflecting: aFailureResult2)
        XCTAssert(debugDescription2.hasPrefix("Left("))
        XCTAssert(debugDescription2.hasSuffix("Error.second)"))
    }
    
    func testSuccessGetter() {
        XCTAssert(aSuccessResult1.isSuccess)
        XCTAssert(aSuccessResult2.isSuccess)
        XCTAssertFalse(aFailureResult1.isSuccess)
        XCTAssertFalse(aFailureResult2.isSuccess)
    }
    
    func testFailureGetter() {
        XCTAssertFalse(aSuccessResult1.isFailure)
        XCTAssertFalse(aSuccessResult2.isFailure)
        XCTAssert(aFailureResult1.isFailure)
        XCTAssert(aFailureResult2.isFailure)
    }
    
    func testSuccessReturnsNoError() {
        XCTAssert(aSuccessResult1.error == nil)
        XCTAssert(aSuccessResult2.error == nil)
    }
    
    func testFailureReturnsError() {
        assertErrorMatches(aFailureResult1.error!, anError1)
        assertErrorMatches(aFailureResult2.error!, anError2)
    }
    
    func testThrowingInitSuccess() {
        func doAction() throws {
            
        }
        
        XCTAssert(Result(doAction) == aSuccessResult1)
        XCTAssert(ContrivedVoidResult(doAction) == aSuccessResult2)
    }
    
    func testThrowingInitFailure() {
        func doAction1() throws {
            throw anError1
        }
        
        func doAction2() throws {
            throw anError2
        }
        
        XCTAssert(Result(doAction1) == aFailureResult1)
        XCTAssert(ContrivedVoidResult(doAction2) == aFailureResult2)
    }
    
    func testReflexiveEquality() {
        XCTAssert(aSuccessResult1 == aSuccessResult1)
        XCTAssert(aSuccessResult2 == aSuccessResult2)
        XCTAssert(aFailureResult1 == aFailureResult1)
        XCTAssert(aFailureResult2 == aFailureResult2)
    }
    
    func testEqualitySameType() {
        XCTAssert(aSuccessResult1 == Result())
        XCTAssert(aSuccessResult2 == ContrivedVoidResult())
        XCTAssertFalse(aSuccessResult1 == aFailureResult1)
        XCTAssertFalse(aSuccessResult2 == aFailureResult2)
        XCTAssert(aFailureResult1 == Result(error: anError1))
        XCTAssert(aFailureResult2 == ContrivedVoidResult(left: anError2))
        XCTAssertFalse(aFailureResult1 == aSuccessResult1)
        XCTAssertFalse(aFailureResult2 == aSuccessResult2)
    }
    
    func testInequalitySameType() {
        XCTAssert(aSuccessResult1 != aFailureResult1)
        XCTAssert(aSuccessResult2 != aFailureResult2)
        XCTAssert(aFailureResult1 != aSuccessResult1)
        XCTAssert(aFailureResult2 != aSuccessResult2)
        XCTAssert(aFailureResult1 != Result(error: Error.second))
    }

    func testEqualityDifferentTypes() {
        XCTAssert(aSuccessResult1 == aSuccessResult2)
        XCTAssertFalse(aSuccessResult1 == aFailureResult2)
        XCTAssert(aFailureResult1 == ContrivedVoidResult(left: anError1))
        XCTAssertFalse(aFailureResult1 == ContrivedVoidResult(left: Error.second))
    }
    
    func testInequalityDifferentTypes() {
        XCTAssertFalse(aSuccessResult1 != aSuccessResult2)
        XCTAssert(aFailureResult1 != aFailureResult2)
    }
    
    fileprivate func doubleSuccess() -> Result<Int> {
        return Result(value: 42)
    }

    fileprivate func doubleFailure() -> Result<Int> {
        return Result(error: Error.third)
    }

    func testFlatMapSuccessSuccess() {
        let x1 = aSuccessResult1.flatMap(doubleSuccess)
        let x2 = aSuccessResult2.flatMap(doubleSuccess)
        XCTAssert(x1.value != nil)
        XCTAssert(x2.value != nil)
    }

    func testFlatMapSuccessFailure() {
        let x1 = aSuccessResult1.flatMap(doubleFailure)
        let x2 = aSuccessResult2.flatMap(doubleFailure)
        assertErrorMatches(x1.error!, Error.third)
        assertErrorMatches(x2.error!, Error.third)
    }

    func testFlatMapFailureSuccess() {
        let x1 = aFailureResult1.flatMap(doubleSuccess)
        let x2 = aFailureResult2.flatMap(doubleSuccess)
        assertErrorMatches(x1.error!, anError1)
        assertErrorMatches(x2.error!, anError2)
    }

    func testFlatMapFailureFailure() {
        let x1 = aFailureResult1.flatMap(doubleFailure)
        let x2 = aFailureResult2.flatMap(doubleFailure)
        assertErrorMatches(x1.error!, anError1)
        assertErrorMatches(x2.error!, anError2)
    }
    
    fileprivate func mappedString() -> String {
        return "Test"
    }
    
    func testMapSuccessNewType() {
        let result1 = aSuccessResult1.map(mappedString)
        assertSuccess(result1, "Test")
        
        let result2 = aSuccessResult2.map(mappedString)
        assertSuccess(result2, "Test")
    }

    func testMapFailureNewType() {
        let result1 = aFailureResult1.map(mappedString)
        assertFailure(result1, Error.first)
        
        let result2 = aFailureResult2.map(mappedString)
        assertFailure(result2, Error.second)
    }
    
}
