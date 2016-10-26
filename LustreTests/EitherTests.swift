//
//  EitherTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 7/26/15.
//  Copyright © 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
@testable import Lustre

class EitherTests: XCTestCase {
    
    let aRightValue = "words"
    let aLeftValue1 = -1
    let aLeftValue2 = 42
    
    fileprivate let aRightEither1 = Either<Int, String>(right: "words")
    fileprivate let aLeftEither1  = Either<Int, String>(left: -1)
    fileprivate let aLeftEither2  = Either<Int, String>(left: 42)
    
    func testDescriptionRight() {
        XCTAssertEqual(String(describing: aRightEither1), aRightValue)
    }
    
    func testDescriptionFailure() {
        XCTAssertEqual(String(describing: aLeftEither1), String(aLeftValue1))
        XCTAssertEqual(String(describing: aLeftEither2), String(aLeftValue2))
    }
    
    func testDebugDescriptionSuccess() {
        XCTAssertEqual(String(reflecting: aRightEither1), "Right(\(String(reflecting: aRightValue)))")
    }
    
    func testDebugDescriptionFailure() {
        XCTAssertEqual(String(reflecting: aLeftEither1), "Left(\(String(reflecting: aLeftValue1)))")
        XCTAssertEqual(String(reflecting: aLeftEither2), "Left(\(String(reflecting: aLeftValue2)))")
    }
    
    func testisLeftGetter() {
        XCTAssertFalse(aRightEither1.isLeft)
        XCTAssert(aLeftEither1.isLeft)
        XCTAssert(aLeftEither1.isLeft)
    }
    
    func testIsRightGetter() {
        XCTAssert(aRightEither1.isRight)
        XCTAssertFalse(aLeftEither1.isRight)
        XCTAssertFalse(aLeftEither1.isRight)
    }
    
    func testRightReturnsRight() {
        XCTAssert(aRightEither1.right == aRightValue)
    }
    
    func testRightReturnsNoLeft() {
        XCTAssert(aRightEither1.left == nil)
    }
    
    func testLeftReturnsLeft() {
        XCTAssert(aLeftEither1.left == aLeftValue1)
    }

    func testLeftReturnsNoRight() {
        XCTAssert(aLeftEither1.right == nil)
    }
    
    func testEquality() {
        XCTAssert(aRightEither1 == aRightEither1)
        XCTAssert(aRightEither1 == Either(right: aRightValue))
        XCTAssertFalse(aRightEither1 == aLeftEither1)
        XCTAssertFalse(aLeftEither1 == aRightEither1)
        XCTAssertFalse(aLeftEither2 == Either(left: aLeftValue2 * 2))
        XCTAssertFalse(aLeftEither1 == aLeftEither2)
    }
    
    func testInequality() {
        XCTAssert(aRightEither1 != aLeftEither1)
        XCTAssert(aLeftEither1 != aRightEither1)
        XCTAssert(aLeftEither2 != Either(left: aLeftValue2 * 2))
        XCTAssert(aLeftEither1 != aLeftEither2)
    }
    
    fileprivate func countCharacters(_ string: String) -> Int {
        return string.characters.count
    }
    
    func testMapRightRight() {
        let x = Either<Int, String>(right: "abcd")
        let y = x.mapRight(countCharacters)
        XCTAssert(y.left == nil)
        XCTAssert(y.right == 4)
    }
    
    func testMapRightLeft() {
        let x = Either<Int, String>(right: "abcd")
        let y = x.mapLeft(-)
        XCTAssert(y.left == nil)
        XCTAssert(y.right == "abcd")
    }
    
    func testMapLeftRight() {
        let x = Either<Int, String>(left: aLeftValue1)
        let y = x.mapRight(countCharacters)
        XCTAssert(y.left == aLeftValue1)
        XCTAssert(y.right == nil)
    }
    
    func testMapLeftLeft() {
        let x = Either<Int, String>(left: aLeftValue2)
        let y = x.mapLeft(-)
        XCTAssert(y.left == -aLeftValue2)
        XCTAssert(y.right == nil)
    }
    
    func doubleLeft(_ x: Int) -> Either<Int, String> {
        return Either(left: x * 2)
    }

    func doubleRight(_ x: String) -> Either<Int, String> {
        return Either(right: x + x)
    }

    func testFlatMapLeftLeft() {
        let x = aLeftEither1.flatMapLeft(doubleLeft)
        XCTAssert(x.left == -2)
        XCTAssert(x.right == nil)
    }

    func testFlatMapRightLeft() {
        let x = aRightEither1.flatMapLeft(doubleLeft)
        XCTAssert(x.left == nil)
        XCTAssert(x.right == aRightValue)
    }
    
    func testFlatMapLeftRight() {
        let x = aLeftEither1.flatMapRight(doubleRight)
        XCTAssert(x.left == aLeftValue1)
        XCTAssert(x.right == nil)
    }
    
    func testFlatMapRightRight() {
        let x = aRightEither1.flatMapRight(doubleRight)
        XCTAssert(x.left == nil)
        XCTAssert(x.right == aRightValue + aRightValue)
    }
    
    func testVoidRightEquality() {
        let voidRight1 = Either<Int, Void>()
        let voidRight2 = Either<Int, Void>(left: 64)
        let voidRight3 = Either<Int, Void>(left: 128)
        
        XCTAssert(voidRight1 == voidRight1)
        XCTAssert(voidRight2 == voidRight2)
        XCTAssert(voidRight3 == voidRight3)
        
        XCTAssertFalse(voidRight1 == voidRight2)
        XCTAssertFalse(voidRight1 == voidRight3)
        XCTAssertFalse(voidRight2 == voidRight3)
        
        XCTAssertFalse(voidRight2 == voidRight1)
        XCTAssertFalse(voidRight3 == voidRight1)
        XCTAssertFalse(voidRight3 == voidRight2)
    }
    
    func testVoidRightInequality() {
        let voidRight1 = Either<Int, Void>()
        let voidRight2 = Either<Int, Void>(left: 64)
        let voidRight3 = Either<Int, Void>(left: 128)
        
        XCTAssertFalse(voidRight1 != voidRight1)
        XCTAssertFalse(voidRight2 != voidRight2)
        XCTAssertFalse(voidRight3 != voidRight3)
        
        XCTAssert(voidRight1 != voidRight2)
        XCTAssert(voidRight1 != voidRight3)
        XCTAssert(voidRight2 != voidRight3)
        
        XCTAssert(voidRight2 != voidRight1)
        XCTAssert(voidRight3 != voidRight1)
        XCTAssert(voidRight3 != voidRight2)
    }
    
}
