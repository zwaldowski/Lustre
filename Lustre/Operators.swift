//
//  Operators.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/29/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// Haskell-like operator for `flatMap`, with chaining working at a higher
/// precedence than function application.
infix operator >>== {
    associativity left
    precedence 150
}

// MARK: Result Base

/// Result failure coalescing
///    success(42) ?? 0 ==> 42
///    failure(error()) ?? 0 ==> 0
public func ??<Result: _ResultType>(result: Result, @autoclosure defaultValue: () -> Result.Value) -> Result.Value {
    return result.analysis(ifSuccess: { $0 }, ifFailure: { _ in defaultValue() })
}

/// Result failure coalescing
///    success(42) ?? success(0) ==> 42
///    failure(error()) ?? success(0) ==> 0
public func ??<Result: _ResultType>(result: Result, @autoclosure defaultValue: () -> Result) -> Result {
    return result.analysis(ifSuccess: {
        _ in result
    }, ifFailure: {
        _ in defaultValue()
    })
}

/// An infix application of a function over a given result.
public func >>==<InResult: _ResultType, OutResult: _ResultType>(result: InResult, @noescape transform: InResult.Value -> OutResult) -> OutResult {
    return Lustre.flatMap(result, transform)
}

// MARK: ResultType

/// An infix application of a function over a given result.
public func >>==<InResult: ResultType, OutResult: ResultType>(result: InResult, @noescape transform: InResult.Value -> OutResult) -> OutResult {
    return result.flatMap(transform)
}

/**
    Type-qualified equality operator over two compatible result types.

    Equality for a result is defined by the equality of the contained types.

    :note: While it is possible to use `==` on results that contain an
    `Equatable` type, results cannot themselves be `Equatable`. This is because
    `T` may not be `Equatable`, and there is no way yet in Swift to define
    define protocol conformance based on specialization.
**/
public func == <LResult: ResultType, RResult: ResultType where LResult.Value: Equatable, RResult.Value == LResult.Value>(lhs: LResult, rhs: RResult) -> Bool {
    return lhs.analysis(ifSuccess: { lValue in
        rhs.analysis(ifSuccess: { lValue == $0 }, ifFailure: { _ in false })
    }, ifFailure: { lError in
        rhs.analysis(ifSuccess: { _ in false }, ifFailure: { lError == $0 })
    })
}

/**
    Type-qualified inequality operator over two compatible result types.

    The same rules apply as the `==` operator over the same types.
**/
public func != <LResult: ResultType, RResult: ResultType where LResult.Value: Equatable, RResult.Value == LResult.Value>(lhs: LResult, rhs: RResult) -> Bool {
    return !(lhs == rhs)
}

/// Type-qualified equality operator over two compatible void-result types.
public func == <LResult: ResultType, RResult: ResultType where LResult.Value == Void, RResult.Value == Void>(lhs: LResult, rhs: RResult) -> Bool {
    return lhs.analysis(ifSuccess: { lValue in
        rhs.analysis(ifSuccess: { _ in true }, ifFailure: { _ in false })
    }, ifFailure: { lError in
        rhs.analysis(ifSuccess: { _ in false }, ifFailure: { lError == $0 })
    })
}

/**
    Type-specific inequality operator over two compatible void-result types.

    The same rules apply as the `==` operator over the same types.
**/
public func != <LResult: ResultType, RResult: ResultType where LResult.Value == Void, RResult.Value == Void>(lhs: LResult, rhs: RResult) -> Bool {
    return !(lhs == rhs)
}

/**
    Type-specific equality operator over two identical result types.

    Equality for a result is defined by the equality of the contained types.

    :note: While it is possible to use `==` on results that contain an
    `Equatable` type, results cannot themselves be `Equatable`. This is because
    `T` may not be `Equatable`, and there is no way yet in Swift to define
    define protocol conformance based on specialization.
**/
public func == <Result: ResultType where Result.Value: Equatable>(lhs: Result, rhs: Result) -> Bool {
    return lhs.analysis(ifSuccess: { lValue in
        rhs.analysis(ifSuccess: { lValue == $0 }, ifFailure: { _ in false })
    }, ifFailure: { lError in
        rhs.analysis(ifSuccess: { _ in false }, ifFailure: { lError == $0 })
    })
}

/**
    Type-specific inequality operator over two identical result types.

    The same rules apply as the `==` operator over the same types.
**/
public func != <Result: ResultType where Result.Value: Equatable>(lhs: Result, rhs: Result) -> Bool {
    return !(lhs == rhs)
}

/// Type-specific equality operator over two identical void-result types.
public func == <Result: ResultType where Result.Value == Void>(lhs: Result, rhs: Result) -> Bool {
    return lhs.analysis(ifSuccess: { lValue in
        rhs.analysis(ifSuccess: { _ in true }, ifFailure: { _ in false })
    }, ifFailure: { lError in
        rhs.analysis(ifSuccess: { _ in false }, ifFailure: { lError == $0 })
    })
}

/// Type-specific inequality operator over two identical void-result types.
public func != <Result: ResultType where Result.Value == Void>(lhs: Result, rhs: Result) -> Bool {
    return !(lhs == rhs)
}
