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

}

// MARK: Remote map/flatMap

extension VoidResult {

    public func map<U, R: CustomResult where R.Value == U>(getValue: () -> U) -> R {
        switch self {
        case Success: return R(getValue())
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

}

extension AnyResult {

    public func map<U, R: CustomResult where R.Value == U>(transform: T -> U) -> R {
        switch self {
        case Success(let value): return R(transform(value as! T))
        case Failure(let error): return R(failure: error)
        }
    }

}

// MARK: Free try

public func try<R: CustomResult>(file: StaticString = __FILE__, line: UWord = __LINE__, @noescape fn: NSErrorPointer -> R.Value?) -> R {
    var err: NSError?
    switch (fn(&err), err) {
    case (.Some(let value), _):
        return R(value)
    case (.None, .Some(let error)):
        return R(failure: error)
    default:
        return R(failure: error(file: file, line: line))
    }
}

// MARK: Free maps

public func map<IR: ResultType, RR: CustomResult>(result: IR, transform: IR.Value -> RR.Value) -> RR {
    if result.isSuccess {
        return RR(transform(result.value))
    } else {
        return RR(failure: result.error!)
    }
}

// MARK: Generic free constructors

public func success<T, Result: CustomResult where Result.Value == T>(value: T) -> Result {
    return Result(value)
}
