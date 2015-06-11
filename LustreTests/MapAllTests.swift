//
//  MapAllTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

class MapAllTests: XCTestCase {
    
    private let testValue = 42
    private let testError = Error.First
    
    private var successResult: Result<Int, Error>  { return success(testValue) }
    private var failureResult: Result<Int, Error>  { return failure(testError) }
    
    private typealias One   = (Int)
    private typealias Two   = (Int, Int)
    private typealias Three = (Int, Int, Int)
    private typealias Four  = (Int, Int, Int, Int)
    private typealias Five  = (Int, Int, Int, Int, Int)
    private typealias Six   = (Int, Int, Int, Int, Int, Int)
    private typealias Seven = (Int, Int, Int, Int, Int, Int, Int)
    private typealias Eight = (Int, Int, Int, Int, Int, Int, Int, Int)
    
    private func makeSuccess(i: Int) -> Result<Int, Error> {
        return successResult.map { $0 + i }
    }
    
    func testMapAllSuccess() {
        let first  = makeSuccess(0)
        let second = makeSuccess(1)
        let third = makeSuccess(2)
        let fourth = makeSuccess(3)
        let fifth = makeSuccess(4)
        let sixth = makeSuccess(5)
        let seventh = makeSuccess(6)
        let eighth = makeSuccess(7)
        
        let final = mapAll(first, second, third, fourth, fifth, sixth, seventh, eighth) { ($0, $1, $2, $3, $4, $5, $6, $7) }
        
        guard let value = final.value else  { XCTFail("unexpected nil"); return }
        XCTAssert(value.0 == first.value)
        XCTAssert(value.1 == second.value)
        XCTAssert(value.2 == third.value)
        XCTAssert(value.3 == fourth.value)
        XCTAssert(value.4 == fifth.value)
        XCTAssert(value.5 == sixth.value)
        XCTAssert(value.6 == seventh.value)
        XCTAssert(value.7 == eighth.value)
    }
    
    func testMapAllFailure() {
        let first  = makeSuccess(0)
        let second = makeSuccess(1)
        let third = makeSuccess(2)
        let fourth = makeSuccess(3)
        let fifth = makeSuccess(4)
        let sixth = makeSuccess(5)
        let seventh = makeSuccess(6)
        let eighth = failureResult
        
        let final = mapAll(first, second, third, fourth, fifth, sixth, seventh, eighth) { ($0, $1, $2, $3, $4, $5, $6, $7) }
        XCTAssert(final.error != nil)
    }
    
    func testFlatMapAllSuccess() {
        let first  = makeSuccess(0)
        let second = makeSuccess(1)
        let third = makeSuccess(2)
        let fourth = makeSuccess(3)
        let fifth = makeSuccess(4)
        let sixth = makeSuccess(5)
        let seventh = makeSuccess(6)
        let eighth = makeSuccess(7)

        let final = flatMapAll(first, second, third, fourth, fifth, sixth, seventh, eighth) { Result<Eight, NSError>(($0, $1, $2, $3, $4, $5, $6, $7))  }
        
        guard let value = final.value else  { XCTFail("unexpected nil"); return }
        XCTAssert(value.0 == first.value)
        XCTAssert(value.1 == second.value)
        XCTAssert(value.2 == third.value)
        XCTAssert(value.3 == fourth.value)
        XCTAssert(value.4 == fifth.value)
        XCTAssert(value.5 == sixth.value)
        XCTAssert(value.6 == seventh.value)
        XCTAssert(value.7 == eighth.value)
    }
    
    func testFlatMapAllFailure() {
        let first  = makeSuccess(0)
        let second = makeSuccess(1)
        let third = makeSuccess(2)
        let fourth = makeSuccess(3)
        let fifth = makeSuccess(4)
        let sixth = makeSuccess(5)
        let seventh = makeSuccess(6)
        let eighth = failureResult
        
        let final = flatMapAll(first, second, third, fourth, fifth, sixth, seventh, eighth) { Result<Eight, NSError>(($0, $1, $2, $3, $4, $5, $6, $7))  }
        XCTAssert(final.error != nil)
    }
    
}
