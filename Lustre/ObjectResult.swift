//
//  ObjectResult.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import Foundation

/// Container for a successful object (`T`) or a failure (`NSError`)
public enum ObjectResult<T: AnyObject> {
    case Success(T)
    case Failure(NSError)
}

extension ObjectResult: ResultType {

    public init(failure: NSError) {
        self = .Failure(failure)
    }

    public var isSuccess: Bool {
        switch self {
        case .Success: return true
        case .Failure: return false
        }
    }

    public var value: T! {
        switch self {
        case .Success(let value): return value
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

extension ObjectResult: Printable {

    /// A textual representation of `self`.
    public var description: String {
        switch self {
        case .Success(let value): return "Success: \(value)"
        case .Failure(let error): return "Failure: \(error)"
        }
    }

}

// MARK: Remote map/flatMap

extension VoidResult {

    public func map<U: AnyObject>(getValue: () -> U) -> ObjectResult<U> {
        switch self {
        case Success: return .Success(getValue())
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap<U: AnyObject>(getValue: () -> ObjectResult<U>) -> ObjectResult<U> {
        switch self {
        case Success(let value): return getValue()
        case Failure(let error): return .Failure(error)
        }
    }

}

extension ObjectResult {

    public func map<U: AnyObject>(transform: T -> U) -> ObjectResult<U> {
        switch self {
        case Success(let value): return .Success(transform(value))
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap<U: AnyObject>(transform: T -> ObjectResult<U>) -> ObjectResult<U> {
        switch self {
        case Success(let value): return transform(value)
        case Failure(let error): return .Failure(error)
        }
    }

}

extension AnyResult {

    public func map<U: AnyObject>(transform: T -> U) -> ObjectResult<U> {
        switch self {
        case Success(let value): return .Success(transform(value as! T))
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap<U: AnyObject>(transform:T -> ObjectResult<U>) -> ObjectResult<U> {
        switch self {
        case Success(let value): return transform(value as! T)
        case Failure(let error): return .Failure(error)
        }
    }

}

// MARK: Free try

public func try<T: AnyObject>(file: StaticString = __FILE__, line: UWord = __LINE__, @noescape fn: NSErrorPointer -> T?) -> ObjectResult<T> {
    var err: NSError?
    switch (fn(&err), err) {
    case (.Some(let value), _):
        return .Success(value)
    case (.None, .Some(let error)):
        return .Failure(error)
    default:
        return .Failure(error(file: file, line: line))
    }
}

// MARK: Free maps

public func map<IR: ResultType, U: AnyObject>(result: IR, transform: IR.Value -> U) -> ObjectResult<U> {
    if result.isSuccess {
        return success(transform(result.value))
    } else {
        return failure(result.error!)
    }
}

// MARK: Free constructors

public func success<T: AnyObject>(value: T) -> ObjectResult<T> {
    return .Success(value)
}
