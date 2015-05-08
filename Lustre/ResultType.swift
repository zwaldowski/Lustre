//
//  Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import Foundation

/// A type that can reflect an either-or state for a given event, though not
/// necessarily mutually exclusively due to limitations in Swift. Ideally,
/// implementations of this type are an `enum` with two cases.
public protocol ResultType: _ResultType {

    /// The value contained by this result iff the event succeeded, else `nil`.
    /// The free function `unbox` can be used to provide an implementation.
    var value: Value? { get }
    
    /// The error object iff the event failed, else `nil`. The free function
    /// `errorOf` can be used to provide an implementation.
    var error: NSError? { get }
    
    /// Return the Result of mapping `transform` over `self`. The free function
    /// `flatMap` can be used to provide an implementation.
    func flatMap<Result: ResultType>(@noescape transform: Value -> Result) -> Result

    /// Returns a new Result by mapping success cases using `transform`, or
    /// re-wrapping the error. The free function `map` can be used to provide
    /// an implementation.
    func map<Result: ResultType>(@noescape transform: Value -> Result.Value) -> Result

}

// MARK: Value analysis

/// The value contained by this result iff the event succeeded, else `nil`.
public func unbox<Result: ResultType>(result: Result) -> Result.Value? {
    return result.analysis(ifSuccess: { $0 }, ifFailure: { _ in nil })
}
