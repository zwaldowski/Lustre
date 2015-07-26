//
//  EitherType+Result.swift
//  Lustre
//
//  Created by Zachary Waldowski on 7/25/15.
//  Copyright © 2014-2015. Some rights reserved.
//

extension EitherType where LeftType == ErrorType {
    
    public init(error: LeftType) {
        self.init(left: error)
    }
    
    public init(value: RightType) {
        self.init(right: value)
    }
    
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

extension EitherType where LeftType == ErrorType {
    
    public init(@noescape _ fn: () throws -> RightType) {
        do {
            self.init(value: try fn())
        } catch {
            self.init(error: error)
        }
    }
    
    public func evaluate() throws -> RightType {
        var error: LeftType!
        guard let value = analysis(ifLeft: { error = $0; return .None }, ifRight: { $0 }) as RightType? else {
            throw error
        }
        return value
    }
    
}

// MARK: Value recovery

extension EitherType where LeftType == ErrorType {
    
    public init(_ value: RightType?, @autoclosure failWith: () -> LeftType) {
        if let value = value {
            self.init(value: value)
        } else {
            self.init(error: failWith())
        }
    }
    
    public func recover(@autoclosure fallbackValue: () -> RightType) -> RightType {
        return analysis(ifLeft: { _ in fallbackValue() }, ifRight: { $0 })
    }
    
}

public func ??<Either: EitherType where Either.LeftType == ErrorType>(lhs: Either, @autoclosure rhs: () -> Either.RightType) -> Either.RightType {
    return lhs.recover(rhs())
}

// MARK: Result equatability

extension ErrorType {
    
    public func matches(other: ErrorType) -> Bool {
        return (self as NSError) == (other as NSError)
    }
    
}

public func ==<LeftEither: EitherType, RightEither: EitherType where LeftEither.LeftType == ErrorType, RightEither.LeftType == ErrorType, LeftEither.RightType: Equatable, RightEither.RightType == LeftEither.RightType>(lhs: LeftEither, rhs: RightEither) -> Bool {
    return lhs.equals(rhs, leftEqual: { $0.matches($1) }, rightEqual: ==)
}

public func !=<LeftEither: EitherType, RightEither: EitherType where LeftEither.LeftType == ErrorType, RightEither.LeftType == ErrorType, LeftEither.RightType: Equatable, RightEither.RightType == LeftEither.RightType>(lhs: LeftEither, rhs: RightEither) -> Bool {
    return !(lhs == rhs)
}

public func ==<LeftEither: EitherType, RightEither: EitherType where LeftEither.LeftType == ErrorType, RightEither.LeftType == ErrorType, LeftEither.RightType == Void, RightEither.RightType == Void>(lhs: LeftEither, rhs: RightEither) -> Bool {
    return lhs.equals(rhs, leftEqual: { $0.matches($1) }, rightEqual: { _ in true })
}

public func !=<LeftEither: EitherType, RightEither: EitherType where LeftEither.LeftType == ErrorType, RightEither.LeftType == ErrorType, LeftEither.RightType == Void, RightEither.RightType == Void>(lhs: LeftEither, rhs: RightEither) -> Bool {
    return !(lhs == rhs)
}
