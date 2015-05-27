//
//  Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import Foundation

/// Container for a successful value (`T`) or a failure (`NSError`).
/// Due to Swift limitations, the `Success` case is type-unsafe. Users should
/// prefer `ObjectResult` or a custom type conforming to `ResultType` instead.
public enum Result<T> {
    case Success(Any)
    case Failure(NSError)
}

extension Result: ResultType {

    /// Creates a result in a success state
    public init(_ value: T) {
        self = .Success(value)
    }

    /// Creates a result in a failure state
    public init(failure: NSError) {
        self = .Failure(failure)
    }
    
    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    public func analysis<R>(@noescape #ifSuccess: T -> R, @noescape ifFailure: NSError -> R) -> R {
        switch self {
        case .Success(let box): return ifSuccess(box as! T)
        case .Failure(let error): return ifFailure(error)
        }
    }

    /// The value contained by this result iff the event succeeded, else `nil`.
    public var value: T? {
        return valueOf(self)
    }
    
    /// The error object iff the event failed, else `nil`.
    public var error: NSError? {
        return errorOf(self)
    }

    /// Return the Result of mapping `transform` over `self`.
    public func flatMap<Result: ResultType>(@noescape transform: T -> Result) -> Result {
        return Lustre.flatMap(self, transform)
    }

}

extension Result: Printable {

    /// A textual representation of `self`.
    public var description: String {
        return analysis(ifSuccess: {
            "Success: \($0)"
        }, ifFailure: {
            "Failure: \($0)"
        })
    }

}

// MARK: Instance mapping

public extension Result {
    
    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    public func map<Result: ResultType>(@noescape transform: T -> Result.Value) -> Result {
        return Lustre.map(self, transform)
    }
    
    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    func map<U>(@noescape transform: T -> U) -> Result<U> {
        return Lustre.map(self, transform)
    }
    
    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    func map<U: AnyObject>(@noescape transform: T -> U) -> ObjectResult<U> {
        return Lustre.map(self, transform)
    }
    
    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    func map(@noescape transform: T -> ()) -> VoidResult {
        return Lustre.map(self, transform)
    }
    
}

// MARK: Free constructors

/// A success `Result` returning `value`.
public func success<T>(value: T) -> Result<T> {
    return .Success(value)
}
