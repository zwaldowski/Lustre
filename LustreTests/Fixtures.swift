//
//  Fixtures.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/10/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
import Lustre

enum Error: ErrorType {
    case First
    case Second
    case Third
}

func assertErrorMatches(@autoclosure expression1: () -> ErrorType, @autoclosure _ expression2: () -> ErrorType, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    XCTAssert(expression1().matches(expression2()), message, file: file, line: line)
}

// MARK: Throwing assertions

func assertThrows<T>(@noescape fn: () throws -> T, @autoclosure _ getError: () -> ErrorType, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    do {
        _ = try fn()
    } catch {
        assertErrorMatches(error, getError(), "Unexpected error in method failure, threw \(error)", file: file, line: line)
    }
}

func assertNoThrow<T>(@noescape expression: () throws -> T, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__, @noescape assertions: T -> ()) {
    do {
        assertions(try expression())
    } catch {
        XCTFail("Unexpected error in method, threw \(error)", file: file, line: line)
    }
}

func assertNoThrow(file: String = __FILE__, line: UInt = __LINE__, @noescape void fn: () throws -> Void) {
    assertNoThrow(fn, file: file, line: line) { _ in }
}

func assertNoThrow<T: Equatable>(@noescape expression: () throws -> T, @autoclosure _ getValue: () -> T, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    assertNoThrow(expression, message, file: file, line: line) {
        XCTAssertEqual($0, getValue())
    }
}

func assertNoThrow<T: Equatable>(@noescape expression: () throws -> [T], @autoclosure _ getValue: () -> [T], _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    assertNoThrow(expression, message, file: file, line: line) {
        XCTAssertEqual($0, getValue())
    }
}

// MARK: Either assertions

func assertFailure<Either: EitherType where Either.LeftType == ErrorType>(@autoclosure expression1: () -> Either, @autoclosure _ expression2: () -> ErrorType, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    assertThrows(expression1().extract, expression2(), message, file: file, line: line)
}

func assertSuccess<Either: EitherType where Either.LeftType == ErrorType>(@autoclosure expression1: () -> Either, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__, @noescape assertions: Either.RightType -> ()) {
    do {
        assertions(try expression1().extract())
    } catch {
        XCTFail("Unexpected error in method, threw \(error)", file: file, line: line)
    }
}

func assertSuccess<Either: EitherType where Either.LeftType == ErrorType, Either.RightType: Equatable>(@autoclosure expression1: () -> Either, @autoclosure _ expression2: () -> Either.RightType, _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    assertSuccess(expression1, message, file: file, line: line) {
        XCTAssertEqual($0, expression2(), message, file: file, line: line)
    }
}

func assertSuccess<Either: EitherType, T: Equatable where Either.LeftType == ErrorType, Either.RightType == [T]>(@autoclosure expression1: () -> Either, @autoclosure _ expression2: () -> [T], _ message: String = "", file: String = __FILE__, line: UInt = __LINE__) {
    assertSuccess(expression1, message, file: file, line: line) {
        XCTAssertEqual($0, expression2(), message, file: file, line: line)
    }
}
