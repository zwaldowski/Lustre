//
//  VoidResult.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import Foundation

/// Container for an anonymous success or a failure (`NSError`)
public enum VoidResult {
    case Success
    case Failure(NSError)
}

extension VoidResult: _ResultType {

    /// Creates a result in a success state
    public init(_: () = ()) {
        self = .Success
    }

    /// Creates a result in a failure state
    public init(failure: NSError) {
        self = .Failure(failure)
    }

    /// Case analysis.
    ///
    /// Returns the value produced by applying a given function in the case of
    /// success, or an alternate given function in the case of failure.
    public func analysis<R>(@noescape #ifSuccess: () -> R, @noescape ifFailure: NSError -> R) -> R {
        switch self {
        case .Success: return ifSuccess()
        case .Failure(let error): return ifFailure(error)
        }
    }
    
}

// A subset of ResultType.
public extension VoidResult {

    /// The error object iff the event failed, else `nil`.
    public var error: NSError? {
        return errorOf(self)
    }

    /// A textual representation of `self`.
    public var description: String {
        return analysis(ifSuccess: { _ in
            "Success: ()"
        }, ifFailure: {
            "Failure: \($0)"
        })
    }
    
    /// Return the result of mapping a result `transform` over `self`.
    public func flatMap<R: ResultType>(@noescape transform: () -> R) -> R {
        return Lustre.flatMap(self, transform)
    }

    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error.
    public func map<Result: ResultType>(@noescape transform: () -> Result.Value) -> Result {
        return Lustre.map(self, transform)
    }

}

/**
    Unlike result types on the whole, all `VoidResult`s are inherently
    equatable.

    :returns: `true` if both results are successes, or if they both contain
    identical errors.
**/
public func == (lhs: VoidResult, rhs: VoidResult) -> Bool {
    switch (lhs, rhs) {
    case (.Success, .Success):
        return true
    case (.Failure(let lError), .Failure(let rError)):
        return lError == rError
    default:
        return false
    }
}

extension VoidResult: Hashable {

    /// An integer hash value describing a unique instance.
    public var hashValue: Int {
        return analysis(ifSuccess: { _ in 0 }, ifFailure: { $0.hash })
    }

}

// MARK: Instance mapping

public extension VoidResult {
    
    /// Return the result of mapping a value `transform` over `self`.
    func map<U>(@noescape transform: () -> U) -> Result<U> {
        return Lustre.map(self, transform)
    }
    
    /// Return the result of mapping a value `transform` over `self`.
    func map<U: AnyObject>(@noescape transform: () -> U) -> ObjectResult<U> {
        return Lustre.map(self, transform)
    }
    
    /// Return the result of executing a function if `self` was successful.
    func map(@noescape fn: () -> ()) -> VoidResult {
        return Lustre.map(self, fn)
    }
    
}

// MARK: Free constructors

/// A success `VoidResult`.
public func success() -> VoidResult {
    return .Success
}
