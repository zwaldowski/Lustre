//
//  AnyResult.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// Container for a successful value (`T`) or a failure (`NSError`).
/// Due to Swift limitations, the `.Success()` case is type-unsafe. Uses should
/// prefer `ObjectResult` or `CustomResult` instead, or use `value` exclusively.
public enum AnyResult<T> {
    case Success(Any)
    case Failure(NSError)
}

extension AnyResult: ResultType {

    public init(failure: NSError) {
        self = .Failure(failure)
    }

    public var isSuccess: Bool {
        switch self {
        case .Success: return true
        case .Failure: return false
        }
    }

    public var value: T? {
        switch self {
        case .Success(let value): return (value as! T)
        case .Failure: return nil
        }
    }

    public var error: NSError? {
        switch self {
        case .Success: return nil
        case .Failure(let error): return error
        }
    }

}

extension AnyResult: Printable {

    /// A textual representation of `self`.
    public var description: String {
        switch self {
        case .Success(let value): return "Success: \(value as! T)"
        case .Failure(let error): return "Failure: \(error)"
        }
    }

}

// MARK: Remote map/flatMap

extension VoidResult {

    public func map<U>(getValue: () -> U) -> AnyResult<U> {
        switch self {
        case Success(let value): return .Success(getValue())
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap<U>(getValue: () -> AnyResult<U>) -> AnyResult<U> {
        switch self {
        case Success(let value): return getValue()
        case Failure(let error): return .Failure(error)
        }
    }

}

extension ObjectResult {

    public func map<U>(transform: T -> U) -> AnyResult<U> {
        switch self {
        case Success(let value): return .Success(transform(value))
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap<U>(transform: T -> AnyResult<U>) -> AnyResult<U> {
        switch self {
        case Success(let value): return transform(value)
        case Failure(let error): return .Failure(error)
        }
    }

}

extension AnyResult {

    public func map<U>(transform: T -> U) -> AnyResult<U> {
        switch self {
        case Success(let value): return .Success(transform(value as! T))
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap<U>(transform: T -> AnyResult<U>) -> AnyResult<U> {
        switch self {
        case Success(let value): return transform(value as! T)
        case Failure(let error): return .Failure(error)
        }
    }

}

// MARK: Free initializes

public func success<T>(value: T) -> AnyResult<T> {
    return .Success(value)
}

public func failure<T>(error: NSError) -> AnyResult<T> {
    return .Failure(error)
}

public func failure<T>(message: String? = nil, file: String = __FILE__, line: Int = __LINE__) -> AnyResult<T> {
    return .Failure(error(message, file: file, line: line))
}

// MARK: Free try

public func try<T>(file: String = __FILE__, line: Int = __LINE__, fn: NSErrorPointer -> T?) -> AnyResult<T> {
    var err: NSError?
    switch (fn(&err), err) {
    case (.Some(let value), _):
        return .Success(value)
    case (.None, .Some(let error)):
        return .Failure(error)
    default:
        return .Failure(error(nil, file: file, line: line))
    }
}

// MARK: Free maps

public func map<U, IR: _ResultType>(result: IR, value: () -> U) -> AnyResult<U> {
    if result.isSuccess {
        return .Success(value())
    }
    return .Failure(result.error!)
}

public func flatMap<T, U, IR: ResultType where IR.Value == T>(result: IR, transform: T -> AnyResult<U>) -> AnyResult<U> {
    switch result.value {
    case .Some(let value): return transform(value)
    case .None: return .Failure(result.error!)
    }
}

public func map<T, U, IR: ResultType where IR.Value == T>(result: IR, transform: T -> U) -> AnyResult<U> {
    switch result.value {
    case .Some(let value): return .Success(transform(value))
    case .None: return .Failure(result.error!)
    }
}
