//
//  ResultBase.swift
//  Lustre
//
//  Created by Zachary Waldowski on 5/8/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// This protocol is an implementation detail of `ResultType`; do
/// not use it directly.
///
/// Its requirements are inherited by `ResultType` and thus must
/// be satisfied by types conforming to that protocol.
public protocol _ResultType {
    
    /// Any contained value returns from the event.
    typealias Value
    
    /// Creates a result in a success state
    init(_ success: Value)

    /// Creates a result in a failure state
    init(failure: NSError)
    
    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    func analysis<R>(@noescape #ifSuccess: Value -> R, @noescape ifFailure: NSError -> R) -> R
    
}

// MARK: Common analyses

/// Case analysis.
///
/// Returns the value produced by applying a given function in the case of
/// success, or an alternate given function in the case of failure.
public func analysis<Result: _ResultType, Return>(result: Result, @noescape ifSuccess success: Result.Value -> Return, @noescape ifFailure failure: NSError -> Return) -> Return {
    return result.analysis(ifSuccess: success, ifFailure: failure)
}

/// The error object iff the event failed, else `nil`.
public func errorOf<Result: _ResultType>(result: Result) -> NSError? {
    return result.analysis(ifSuccess: { _ in nil }, ifFailure: { $0 })
}

/// Returns the Result of mapping `transform` over `self`.
public func flatMap<InResult: _ResultType, OutResult: _ResultType>(result: InResult, @noescape transform: InResult.Value -> OutResult) -> OutResult {
    return result.analysis(ifSuccess: transform, ifFailure: failure)
}

// MARK: Generic free initializers

/**
    A failure result type returning a given error.

    Unless the result of this function is being passed or returned to a context
    that explicitly defines the needed result type, you must explicitly assign
    as type, otherwise Swift has no information to decide.

    For example:
       let failure: Result<Bool> = failure(error)

    :param: An instance of an `NSError`
    :returns: A suitable result type for the given context.
**/
public func failure<Result: _ResultType>(error: NSError) -> Result {
    return Result(failure: error)
}

/**
    A failure result type returning an error with a given message.

    Unless the result of this function is being passed or returned to a context
    that explicitly defines the needed result type, you must explicitly assign
    as type, otherwise Swift has no information to decide.

    For example:
       let failure: Result<Bool> = failure("Parsing the object failed!")

    :param: message An optional description of the problem.
    :param: function A statically-known version of the calling function.
    :param: file A statically-known version of the calling file in the project.
    :param: line A statically-known version of the calling line in code.
    :returns: A suitable result type for the given context.

**/
public func failure<Result: _ResultType>(_ message: String? = nil, function: StaticString = __FUNCTION__, file: StaticString = __FILE__, line: UWord = __LINE__) -> Result {
    return Result(failure: error(message, function: function, file: file, line: line))
}

/// A success Result returning `value`.
public func success<Result: _ResultType>(value: Result.Value) -> Result {
    return Result(value)
}
