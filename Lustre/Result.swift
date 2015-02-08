//
//  Result.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// This protocol is an implementation detail of `ResultType` for special-cased;
/// success types of `Void`. Do not use it directly.
///
/// Its requirements are inherited by `ResultType` and thus must
/// be satisfied by types conforming to that protocol.
public protocol _ResultType {

    /// Returns true if the event succeeded.
    var isSuccess: Bool { get }

    /// The error object iff the event failed and `isSuccess` is `false`.
    var error: NSError? { get }
}

/// A type that can reflect an either-or state for a given event, though not
/// necessarily mutually exclusively due to limitations in Swift. Ideally,
/// implementations of this type are an `enum` with two cases.
public protocol ResultType: _ResultType {

    /// Any contained value returns from the event.
    typealias Value

    /// The value contained by this result. If `isSuccess` is `true`, this
    /// should not be `nil`.
    var value: Value? { get }
}

/// Key for the __FILE__ constant in generated errors
public let ErrorFileKey = "errorFile"

/// Key for the __LINE__ constant in generated errors
public let ErrorLineKey = "errorLine"

/// Generate an automatic domainless `NSError`.
func error(message: String?, file: String = __FILE__, line: Int = __LINE__) -> NSError {
    var userInfo: [String: AnyObject] = [
        ErrorFileKey: file,
        ErrorLineKey: line
    ]

    if let message = message {
        userInfo[NSLocalizedDescriptionKey] = message
    }

    return NSError(domain: "", code: 0, userInfo: userInfo)
}

// MARK: Operators

/// Note that while it is possible to use `==` on results that contain an
/// `Equatable` type, results cannot themselves be `Equatable`. This is because
/// `T` may not be `Equatable`, and there is no way yet in Swift to define
/// define protocol conformance based on specialization.
public func == <T: Equatable, LResult: ResultType, RResult: ResultType where LResult.Value == T, RResult.Value == T>(lhs: LResult, rhs: RResult) -> Bool {
    switch (lhs.isSuccess, rhs.isSuccess) {
    case (true, true): return lhs.value == rhs.value
    case (false, false): return lhs.error == rhs.error
    default: return false
    }
}

/// Same rules apply as `==`.
public func != <T: Equatable, LResult: ResultType, RResult: ResultType where LResult.Value == T, RResult.Value == T>(lhs: LResult, rhs: RResult) -> Bool {
    switch (lhs.isSuccess, rhs.isSuccess) {
    case (true, true): return lhs.value != rhs.value
    case (false, false): return lhs.error != rhs.error
    default: return false
    }
}

/// Result failure coalescing
///    success(42) ?? 0 ==> 42
///    failure(error()) ?? 0 ==> 0
public func ??<T, Result: ResultType where Result.Value == T>(result: Result, defaultValue: @autoclosure () -> T) -> T {
    return result.value ?? defaultValue()
}
