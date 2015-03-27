//
//  CustomResult.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright (c) 2014-2015. All rights reserved.
//

import Foundation

// MARK: Protocols

/// A custom result type that can be created with some kind of success value
public protocol CustomResult: ResultType {
    
    /// Creates a result in a success state
    init(_ success: Value)
    
    /// Creates a result in a failure state
    init(failure: NSError)

}

// MARK: Remote map/flatMap

extension VoidResult {

    public func map<U, R: CustomResult where R.Value == U>(getValue: () -> U) -> R {
        switch self {
        case Success: return R(getValue())
        case Failure(let error): return R(failure: error)
        }
    }

    public func flatMap<U, R: CustomResult where R.Value == U>(getValue: () -> R) -> R {
        switch self {
        case Success(let value): return getValue()
        case Failure(let error): return R(failure: error)
        }
    }

}

extension ObjectResult {

    public func map<U, R: CustomResult where R.Value == U>(transform: T -> U) -> R {
        switch self {
        case Success(let value): return R(transform(value))
        case Failure(let error): return R(failure: error)
        }
    }

    public func flatMap<U, R: CustomResult where R.Value == U>(transform: T -> R) -> R {
        switch self {
        case Success(let value): return transform(value)
        case Failure(let error): return R(failure: error)
        }
    }

}

extension AnyResult {

    public func map<U, R: CustomResult where R.Value == U>(transform: T -> U) -> R {
        switch self {
        case Success(let value): return R(transform(value as! T))
        case Failure(let error): return R(failure: error)
        }
    }

    public func flatMap<U, R: CustomResult where R.Value == U>(transform: T -> R) -> R {
        switch self {
        case Success(let value): return transform(value as! T)
        case Failure(let error): return R(failure: error)
        }
    }

}

// MARK: Free try

public func try<T, R: CustomResult where R.Value == T>(file: StaticString = __FILE__, line: UWord = __LINE__, fn: NSErrorPointer -> T?) -> R {
    var err: NSError?
    switch (fn(&err), err) {
    case (.Some(let value), _):
        return R(value)
    case (.None, .Some(let error)):
        return R(failure: error)
    default:
        return R(failure: error(nil, file: file, line: line))
    }
}

// MARK: Free maps

public func map<T, U, IR: ResultType, RR: CustomResult where IR.Value == T, RR.Value == U>(result: IR, transform: T -> U) -> RR {
    switch result.value {
    case .Some(let value): return RR(transform(value))
    case .None: return RR(failure: result.error!)
    }
}

public func flatMap<T, U, IR: ResultType, RR: CustomResult where IR.Value == T, RR.Value == U>(result: IR, transform: T -> RR) -> RR {
    switch result.value {
    case .Some(let value): return transform(value)
    case .None: return RR(failure: result.error!)
    }
}

public func map<U, IR: _ResultType, RR: CustomResult where RR.Value == U>(result: IR, value: () -> U) -> RR {
    if result.isSuccess {
        return RR(value())
    }
    return RR(failure: result.error!)
}

// MARK: Generic free constructors

public func success<T, Result: CustomResult where Result.Value == T>(value: T) -> Result {
    return Result(value)
}

public func failure<Result: CustomResult>(error: NSError) -> Result {
    return Result(failure: error)
}

public func failure<Result: CustomResult>(_ message: String? = nil, file: StaticString = __FILE__, line: UWord = __LINE__) -> Result {
    return Result(failure: error(message, file: file, line: line))
}
