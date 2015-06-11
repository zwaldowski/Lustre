//
//  Operators.swift
//  Lustre
//
//  Created by Zachary Waldowski on 3/29/15.
//  Copyright © 2014-2015 Zachary Waldowski. All rights reserved.
//

/// Result failure coalescing
///    success(42) ?? 0 ==> 42
///    failure(error()) ?? 0 ==> 0
public func ??<Result: ResultType>(result: Result, @autoclosure defaultValue: () -> Result.Value) -> Result.Value {
    return result.analysis(ifSuccess: { $0 }, ifFailure: { _ in defaultValue() })
}

/**
    Type-specific equality operator over two identical result types.

    Equality for a result is defined by the equality of the contained types.

    :note: While it is possible to use `==` on results that contain an
    `Equatable` type, results cannot themselves be `Equatable`. This is because
    `T` may not be `Equatable`, and there is no way yet in Swift to define
    define protocol conformance based on specialization.
**/
public func == <R: ResultType where R.Value: Equatable, R.Error: Equatable>(lhs: R, rhs: R) -> Bool {
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
public func != <R: ResultType where R.Value: Equatable, R.Error: Equatable>(lhs: R, rhs: R) -> Bool {
    return !(lhs == rhs)
}

/// Type-specific equality operator over two identical void-result types.
public func == <R: ResultType where R.Value == Void, R.Error: Equatable>(lhs: R, rhs: R) -> Bool {
    return lhs.analysis(ifSuccess: { lValue in
        rhs.analysis(ifSuccess: { _ in true }, ifFailure: { _ in false })
    }, ifFailure: { lError in
        rhs.analysis(ifSuccess: { _ in false }, ifFailure: { lError == $0 })
    })
}

/// Type-specific inequality operator over two identical void-result types.
public func != <R: ResultType where R.Value == Void, R.Error: Equatable>(lhs: R, rhs: R) -> Bool {
    return !(lhs == rhs)
}

/**
    Type-qualified equality operator over two compatible result types.

    Equality for a result is defined by the equality of the contained types.

    :note: While it is possible to use `==` on results that contain an
    `Equatable` type, results cannot themselves be `Equatable`. This is because
    `T` may not be `Equatable`, and there is no way yet in Swift to define
    define protocol conformance based on specialization.
**/
public func == <LResult: ResultType, RResult: ResultType where LResult.Value: Equatable, LResult.Error: Equatable, LResult.Value == RResult.Value, LResult.Error == RResult.Error>(lhs: LResult, rhs: RResult) -> Bool {
    return lhs.analysis(ifSuccess: { lValue in
        return rhs.analysis(ifSuccess: { lValue == $0 }, ifFailure: { _ in false })
    }, ifFailure: { lError in
        return rhs.analysis(ifSuccess: { _ in false }, ifFailure: { lError == $0 })
    })
}

/**
    Type-qualified inequality operator over two compatible result types.

    The same rules apply as the `==` operator over the same types.
**/
public func != <LResult: ResultType, RResult: ResultType where LResult.Value: Equatable, LResult.Error: Equatable, LResult.Value == RResult.Value, LResult.Error == RResult.Error>(lhs: LResult, rhs: RResult) -> Bool {
    return !(lhs == rhs)
}

/// Type-qualified equality operator over two compatible result types.
public func == <LResult: ResultType, RResult: ResultType where LResult.Value == Void, RResult.Value == Void, LResult.Error: Equatable, LResult.Error == RResult.Error>(lhs: LResult, rhs: RResult) -> Bool {
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
public func != <LResult: ResultType, RResult: ResultType where LResult.Value == Void, RResult.Value == Void, LResult.Error: Equatable, LResult.Error == RResult.Error>(lhs: LResult, rhs: RResult) -> Bool {
    return !(lhs == rhs)
}
