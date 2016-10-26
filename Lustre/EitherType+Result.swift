//
//  EitherType+Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 7/25/15.
//  Copyright © 2014-2015. Some rights reserved.
//

extension EitherType where LeftType == Error {
    
    public var isSuccess: Bool {
        return isRight
    }
    
    public var isFailure: Bool {
        return isLeft
    }
    
    public var error: LeftType? {
        return left
    }
    
    public var value: RightType? {
        return right
    }
    
}

// MARK: Throws compatibility 

extension EitherType where LeftType == Error {
    
    public init(_ fn: () throws -> RightType) {
        do {
            self.init(right: try fn())
        } catch {
            self.init(left: error)
        }
    }
    
    public func extract() throws -> RightType {
        var error: LeftType!
        guard let value = analysis(ifLeft: { error = $0; return .none }, ifRight: { $0 }) as RightType? else {
            throw error
        }
        return value
    }
    
}

// MARK: Value recovery

extension EitherType where LeftType == Error {
    
    public init(_ value: RightType?, failWith: @autoclosure () -> LeftType) {
        if let value = value {
            self.init(right: value)
        } else {
            self.init(left: failWith())
        }
    }
    
    public func recover(_ fallbackValue: @autoclosure () -> RightType) -> RightType {
        return analysis(ifLeft: { _ in fallbackValue() }, ifRight: { $0 })
    }
    
}

public func ??<Either: EitherType>(lhs: Either, rhs: @autoclosure () -> Either.RightType) -> Either.RightType where Either.LeftType == Error {
    return lhs.recover(rhs())
}

// MARK: Result equatability

extension Error {
    
    public func matches(_ other: Error) -> Bool {
        return (self as NSError) == (other as NSError)
    }
    
}

public func ==<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType == Error, RightEither.LeftType == Error, LeftEither.RightType: Equatable, RightEither.RightType == LeftEither.RightType {
    return lhs.equals(rhs, leftEqual: { $0.matches($1) }, rightEqual: ==)
}

public func !=<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType == Error, RightEither.LeftType == Error, LeftEither.RightType: Equatable, RightEither.RightType == LeftEither.RightType {
    return !(lhs == rhs)
}

public func ==<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType == Error, RightEither.LeftType == Error, LeftEither.RightType == Void, RightEither.RightType == Void {
    return lhs.equals(rhs, leftEqual: { $0.matches($1) }, rightEqual: { _ in true })
}

public func !=<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType == Error, RightEither.LeftType == Error, LeftEither.RightType == Void, RightEither.RightType == Void {
    return !(lhs == rhs)
}
