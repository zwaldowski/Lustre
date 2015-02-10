//
//  VoidResult.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// Container for an anonymous success or a failure (`NSError`)
public enum VoidResult {
    case Success
    case Failure(NSError)
}

extension VoidResult: _ResultType {

    public init(failure: NSError) {
        self = .Failure(failure)
    }

    public var isSuccess: Bool {
        switch self {
        case .Success: return true
        case .Failure: return false
        }
    }

    public var error: NSError? {
        switch self {
        case .Success: return nil
        case .Failure(let error): return error
        }
    }

}

extension VoidResult: Printable {

    /// A textual representation of `self`.
    public var description: String {
        switch self {
        case .Success(let value): return "Success: ()"
        case .Failure(let error): return "Failure: \(error)"
        }
    }

}

extension VoidResult: Equatable {}

public func == (lhs: VoidResult, rhs: VoidResult) -> Bool {
    switch (lhs.isSuccess, rhs.isSuccess) {
    case (true, true): return true
    case (false, false): return lhs.error == rhs.error
    default: return false
    }
}

// MARK: Remote map/flatMap

extension VoidResult {

    public func map(fn: () -> ()) -> VoidResult {
        switch self {
        case Success: fn(); return .Success
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap(getValue: () -> VoidResult) -> VoidResult {
        switch self {
        case Success(let value): return getValue()
        case Failure(let error): return .Failure(error)
        }
    }

}

extension ObjectResult {

    public func map<U: AnyObject>(fn: T -> ()) -> VoidResult {
        switch self {
        case Success(let value): fn(value); return .Success
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap(transform: T -> VoidResult) -> VoidResult {
        switch self {
        case Success(let value): return transform(value)
        case Failure(let error): return .Failure(error)
        }
    }

}

extension AnyResult {

    public func map(fn: T -> ()) -> VoidResult {
        switch self {
        case Success(let value): fn(value as! T); return .Success
        case Failure(let error): return .Failure(error)
        }
    }

    public func flatMap(transform: T -> VoidResult) -> VoidResult {
        switch self {
        case Success(let value): return transform(value as! T)
        case Failure(let error): return .Failure(error)
        }
    }

}

// MARK: Free initializes

public func success() -> VoidResult {
    return .Success
}

public func failure(error: NSError) -> VoidResult {
    return .Failure(error)
}

public func failure(message: String? = nil, file: String = __FILE__, line: Int = __LINE__) -> VoidResult {
    return .Failure(error(message, file: file, line: line))
}

// MARK: Free try

public func try(f: NSErrorPointer -> Bool, file: String = __FILE__, line: Int = __LINE__) -> VoidResult {
    var err: NSError?
    switch (f(&err), err) {
    case (true, _):
        return .Success
    case (false, .Some(let error)):
        return .Failure(error)
    default:
        return .Failure(error(nil, file: file, line: line))
    }
}

public func map<U: AnyObject, IR: _ResultType>(result: IR, fn: () -> ()) -> VoidResult {
    if result.isSuccess {
        fn()
        return .Success
    }
    return .Failure(result.error!)
}

// MARK: Free maps

public func map<T, IR: ResultType where IR.Value == T>(result: IR, fn: T -> ()) -> VoidResult {
    switch result.value {
    case .Some(let value): fn(value); return .Success
    case .None: return .Failure(result.error!)
    }
}

public func flatMap<T, IR: ResultType where IR.Value == T>(result: IR, transform: T -> VoidResult) -> VoidResult {
    switch result.value {
    case .Some(let value): return transform(value)
    case .None: return .Failure(result.error!)
    }
}
