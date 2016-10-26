//
//  Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015. Some rights reserved.
//

public enum Result<T> {
    case failure(Error)
    case success(T)
    
    public init(error: Error) {
        self = .failure(error)
    }
    
    public init(value: T) {
        self = .success(value)
    }
}

extension Result: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        switch self {
        case .failure(let error): return String(describing: error)
        case .success(let value): return String(describing: value)
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .failure(let error): return "Failure(\(String(reflecting: error)))"
        case .success(let value): return "Success(\(String(reflecting: value)))"
        }
    }
    
}

extension Result: EitherType {
    
    public init(left error: Error) {
        self.init(error: error)
    }
    
    public init(right value: T) {
        self.init(value: value)
    }
    
    public func analysis<Result>(ifLeft: (Error) -> Result, ifRight: (T) -> Result) -> Result {
        switch self {
        case .failure(let error): return ifLeft(error)
        case .success(let value): return ifRight(value)
        }
    }
    
}

extension EitherType where LeftType == Error {
    
    public func flatMap<Value>(_ transform: (RightType) -> Result<Value>) -> Result<Value> {
        return analysis(ifLeft: Result.failure, ifRight: transform)
    }
    
    public func map<Value>(_ transform: (RightType) -> Value) -> Result<Value> {
        return flatMap { .success(transform($0)) }
    }
    
    public func recoverWith(_ fallbackResult: @autoclosure () -> Result<RightType>) -> Result<RightType> {
        return analysis(ifLeft: { _ in fallbackResult() }, ifRight: Result.success)
    }
    
}

public func ??<Either: EitherType>(lhs: Either, rhs: @autoclosure () -> Result<Either.RightType>) -> Result<Either.RightType> where Either.LeftType == Error {
    return lhs.recoverWith(rhs())
}
