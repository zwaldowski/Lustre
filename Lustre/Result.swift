//
//  Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015. All rights reserved.
//

/// Container for a successful value (`T`) or a failure (`Error`).
/// For concrete use cases, users might prefer a custom enum conforming to
/// `ResultType`.
public enum Result<T, Error: ErrorType>: ResultType {
    case Success(T)
    case Failure(Error)

    /// Creates a result in a success state
    public init(_ value: T) {
        self = .Success(value)
    }
    
    /// Creates a result in a failure state
    public init(failure: Error) {
        self = .Failure(failure)
    }
    
    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    public func analysis<R>(@noescape ifSuccess ifSuccess: T -> R, @noescape ifFailure: Error -> R) -> R {
        switch self {
        case .Success(let value): return ifSuccess(value)
        case .Failure(let error): return ifFailure(error)
        }
    }

}

public extension ResultType {
    
    /// Returns a new Result by mapping success cases by using `transform`, or
    /// re-wrapping the error.
    func map<U>(@noescape transform: Value -> U) -> Result<U, Error> {
        return flatMap { success(transform($0)) }
    }
    
}
