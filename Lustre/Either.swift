//
//  Either.swift
//  Lustre
//
//  Created by Zachary Waldowski on 7/24/15.
//  Copyright © 2014-2015. Some rights reserved.
//

public enum Either<T, U> {
    case Left(T)
    case Right(U)
}

extension Either: EitherType {
    
    public init(left: T) {
        self = .Left(left)
    }
    
    public init(right: U) {
        self = .Right(right)
    }
    
    public func analysis<Result>(ifLeft: (T) -> Result, ifRight: (U) -> Result) -> Result {
        switch self {
        case .Left(let value): return ifLeft(value)
        case .Right(let value): return ifRight(value)
        }
    }
    
}

extension EitherType {
    
    public func flatMapLeft<NewLeft>(_ transform: (LeftType) -> Either<NewLeft, RightType>) -> Either<NewLeft, RightType> {
        return analysis(ifLeft: transform, ifRight: Either.Right)
    }
    
    public func mapLeft<NewLeft>(_ transform: (LeftType) -> NewLeft) -> Either<NewLeft, RightType> {
        return flatMapLeft { .Left(transform($0)) }
    }
    
    public func flatMapRight<NewRight>(_ transform: (RightType) -> Either<LeftType, NewRight>) -> Either<LeftType, NewRight> {
        return analysis(ifLeft: Either.Left, ifRight: transform)
    }
    
    public func mapRight<NewRight>(_ transform: (RightType) -> NewRight) -> Either<LeftType, NewRight> {
        return flatMapRight { .Right(transform($0)) }
    }
    
}
