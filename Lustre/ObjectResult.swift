//
//  ObjectResult.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import Foundation

private enum ObjectResultStorage {
    case Success(AnyObject)
    case Failure(NSError)
}

/// Container for a successful object (`T`) or a failure (`NSError`).
public struct ObjectResult<T: AnyObject>: ResultType {

    private let storage: ObjectResultStorage

    /// Creates a result in a success state
    public init(_ object: T) {
        storage = .Success(object)
    }

    /// Creates a result in a failure state
    public init(failure: NSError) {
        storage = .Failure(failure)
    }
    
    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    public func analysis<R>(@noescape #ifSuccess: T -> R, @noescape ifFailure: NSError -> R) -> R {
        switch storage {
        case .Success(let object): return ifSuccess(unsafeDowncast(object))
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
    
    /// A textual representation of `self`.
    public var description: String {
        return descriptionOf(self)
    }

    /// Return the Result of mapping `transform` over `self`.
    public func flatMap<Result: ResultType>(@noescape transform: T -> Result) -> Result {
        return Lustre.flatMap(self, transform)
    }

    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    public func map<Result: ResultType>(@noescape transform: T -> Result.Value) -> Result {
        return Lustre.map(self, transform)
    }

}

// MARK: Instance mapping

public extension ObjectResult {
    
    /// Return the result of mapping a value `transform` over `self`.
    func map<U>(@noescape transform: T -> U) -> Result<U> {
        return Lustre.map(self, transform)
    }

    /// Return the result of mapping a value `transform` over `self`.
    func map<U: AnyObject>(@noescape transform: T -> U) -> ObjectResult<U> {
        return Lustre.map(self, transform)
    }
    
    /// Return the result of executing a function if `self` was successful.
    func map(@noescape fn: T -> ()) -> VoidResult {
        return Lustre.map(self, fn)
    }

}

// MARK: Free constructors

/// A success `ObjectResult` returning a reference type `value`.
public func success<T: AnyObject>(value: T) -> ObjectResult<T> {
    return ObjectResult(value)
}
