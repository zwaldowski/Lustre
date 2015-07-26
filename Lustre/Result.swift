//
//  Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 2/7/15.
//  Copyright © 2014-2015. Some rights reserved.
//

public enum Result<T> {
    case Failure(ErrorType)
    case Success(T)
    
    public init(error: ErrorType) {
        self = .Failure(error)
    }
    
    public init(value: T) {
        self = .Success(value)
    }
}

extension Result: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        switch self {
        case .Failure(let error): return String(error)
        case .Success(let value): return String(value)
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .Failure(let error): return "Failure(\(String(reflecting: error)))"
        case .Success(let value): return "Success(\(String(reflecting: value)))"
        }
    }
    
}

extension Result: EitherType {
    
    public init(left error: ErrorType) {
        self.init(error: error)
    }
    
    public init(right value: T) {
        self.init(value: value)
    }
    
    public func analysis<Result>(@noescape ifLeft ifLeft: ErrorType -> Result, @noescape ifRight: T -> Result) -> Result {
        switch self {
        case .Failure(let error): return ifLeft(error)
        case .Success(let value): return ifRight(value)
        }
    }
    
}

extension EitherType where LeftType == ErrorType {
    
    public func flatMap<Value>(@noescape transform: RightType -> Result<Value>) -> Result<Value> {
        return analysis(ifLeft: Result.Failure, ifRight: transform)
    }
    
    public func map<Value>(@noescape transform: RightType -> Value) -> Result<Value> {
        return flatMap { .Success(transform($0)) }
    }
    
    public func recoverWith(@autoclosure fallbackResult: () -> Result<RightType>) -> Result<RightType> {
        return analysis(ifLeft: { _ in fallbackResult() }, ifRight: Result.Success)
    }
    
}

public func ??<Either: EitherType where Either.LeftType == ErrorType>(lhs: Either, @autoclosure rhs: () -> Result<Either.RightType>) -> Result<Either.RightType> {
    return lhs.recoverWith(rhs())
}
