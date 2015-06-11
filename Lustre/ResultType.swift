//
//  Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015 Zachary Waldowski. All rights reserved.
//
 
public protocol _ResultDefaultsType {
    
    /// Any contained value returned from the event.
    typealias Value
    
    /// Any contained error returned from the event.
    typealias Error: ErrorType
    
    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    func analysis<R>(@noescape ifSuccess ifSuccess: Value -> R, @noescape ifFailure: Error -> R) -> R
    
}

extension _ResultDefaultsType {
    
    /// A description of the value or error contained by the given result.
    public var description: String {
        return analysis(ifSuccess: {
            String($0)
        }, ifFailure: {
            String($0)
        })
    }
    
    /// A description of the value or error contained by the given result.
    public var debugDescription: String {
        return analysis(ifSuccess: {
            "Success: \($0)"
        }, ifFailure: {
            "Failure: \($0)"
        })
    }
    
}

/// A type that can reflect an either-or state for a given event. Ideally,
/// implementations of this type are an `enum` with two or more cases.
public protocol ResultType: _ResultDefaultsType, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// Any contained value returned from the event.
    typealias Value
    
    /// Any contained error returned from the event.
    typealias Error: ErrorType
    
    /// Creates a result in a success state
    init(_ success: Value)
    
    /// Creates a result in a failure state
    init(failure: Error)
    
    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    func analysis<R>(@noescape ifSuccess ifSuccess: Value -> R, @noescape ifFailure: Error -> R) -> R

}

public extension ResultType {
    
    /// The value contained by this result iff the event succeeded, else `nil`.
    var value: Value? {
        return analysis(ifSuccess: { .Some($0) }, ifFailure: { _ in nil })
    }
    
    /// The error object iff the event failed, else `nil`.
    var error: Error? {
        return analysis(ifSuccess: { _ in nil }, ifFailure: { .Some($0) })
    }
    
    /// Returns the Result of mapping `transform` over `self`.
    public func flatMap<Result: ResultType where Result.Error == Error>(@noescape transform: Value -> Result) -> Result {
        return analysis(ifSuccess: transform, ifFailure: failure)
    }
    
    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    public func map<Result: ResultType where Result.Error == Error>(@noescape transform: Value -> Result.Value) -> Result {
        return flatMap { Result(transform($0)) }
    }
    
}

/// A success Result returning `value`.
public func success<Result: ResultType>(value: Result.Value) -> Result {
    return Result(value)
}

/// A failure result type returning a given error.
public func failure<Result: ResultType>(error: Result.Error) -> Result {
    return Result(failure: error)
}

public enum NoError: Equatable, ErrorType {}

public func ==(lhs: NoError, rhs: NoError) -> Bool { return true }
