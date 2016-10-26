//
//  Fixtures.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/10/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
import Lustre

enum Error: Swift.Error {
    case first
    case second
    case third
}

func assertErrorMatches(_ expression1: @autoclosure () -> Swift.Error, _ expression2: @autoclosure () -> Swift.Error, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    XCTAssert(expression1().matches(expression2()), message, file: file, line: line)
}

// MARK: Throwing assertions

func assertThrows<T>(_ fn: () throws -> T, _ getError: @autoclosure () -> Swift.Error, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    do {
        _ = try fn()
    } catch {
        assertErrorMatches(error as! Error, getError(), "Unexpected error in method failure, threw \(error)", file: file, line: line)
    }
}

func assertNoThrow<T>(_ expression: () throws -> T, _ message: String = "", file: StaticString = #file, line: UInt = #line, assertions: (T) -> ()) {
    do {
        assertions(try expression())
    } catch {
        XCTFail("Unexpected error in method, threw \(error)", file: file, line: line)
    }
}

func assertNoThrow(_ file: StaticString = #file, line: UInt = #line, void fn: () throws -> Void) {
    assertNoThrow(fn, file: file, line: line) { _ in }
}

func assertNoThrow<T: Equatable>(_ expression: () throws -> T, _ getValue: @autoclosure () -> T?, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    assertNoThrow(expression, message, file: file, line: line) { (value: T) in
        XCTAssertEqual(value, getValue())
    }
}

func assertNoThrow<T: Equatable>(_ expression: () throws -> [T], _ getValue: @autoclosure () -> [T], _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    assertNoThrow(expression, message, file: file, line: line) {
        XCTAssertEqual($0, getValue())
    }
}

// MARK: Either assertions

func assertFailure<Either: EitherType>(_ expression1: @autoclosure () -> Either, _ expression2: @autoclosure () -> Swift.Error, _ message: String = "", file: StaticString = #file, line: UInt = #line) where Either.LeftType == Swift.Error {
    assertThrows(expression1().extract, expression2(), message, file: file, line: line)
}

func assertSuccess<Either: EitherType>(_ expression1: @autoclosure () -> Either, _ message: String = "", file: StaticString = #file, line: UInt = #line, assertions: (Either.RightType) -> ()) where Either.LeftType == Swift.Error {
    do {
        assertions(try expression1().extract())
    } catch {
        XCTFail("Unexpected error in method, threw \(error)", file: file, line: line)
    }
}

func assertSuccess<Either: EitherType>(_ expression1: @autoclosure () -> Either, _ expression2: @autoclosure () -> Either.RightType, _ message: String = "", file: StaticString = #file, line: UInt = #line) where Either.LeftType == Swift.Error, Either.RightType: Equatable {
    assertSuccess(expression1, message, file: file, line: line) {
        XCTAssertEqual($0, expression2(), message, file: file, line: line)
    }
}

func assertSuccess<Either: EitherType, T: Equatable>(_ expression1: @autoclosure () -> Either, _ expression2: @autoclosure () -> [T], _ message: String = "", file: StaticString = #file, line: UInt = #line) where Either.LeftType == Swift.Error, Either.RightType == [T] {
    assertSuccess(expression1, message, file: file, line: line) {
        XCTAssertEqual($0, expression2(), message, file: file, line: line)
    }
}
