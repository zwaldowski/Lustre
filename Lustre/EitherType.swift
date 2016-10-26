//
//  EitherType.swift
//  Lustre
//
//  Created by Zachary Waldowski on 7/24/15.
//  Copyright © 2014-2015. Some rights reserved.
//

public protocol EitherType: CustomStringConvertible, CustomDebugStringConvertible {
    associatedtype LeftType
    associatedtype RightType
    
    init(left: LeftType)
    init(right: RightType)
    
    func analysis<Result>(ifLeft: (LeftType) -> Result, ifRight: (RightType) -> Result) -> Result
}

extension EitherType {
    
    public var description: String {
        return analysis(ifLeft: { String(describing: $0) }, ifRight: { String(describing: $0) })
    }
    
    public var debugDescription: String {
        return analysis(ifLeft: {
            "Left(\(String(reflecting: $0)))"
        }, ifRight: {
            "Right(\(String(reflecting: $0)))"
        })
    }
    
}

// MARK: State attributes

extension EitherType {
    
    public var isLeft: Bool {
        return analysis(ifLeft: { _ in true }, ifRight: { _ in false })
    }
    
    public var isRight: Bool {
        return analysis(ifLeft: { _ in false }, ifRight: { _ in true })
    }
    
    public var left: LeftType? {
        return analysis(ifLeft: { $0 }, ifRight: { _ in nil })
    }
    
    public var right: RightType? {
        return analysis(ifLeft: { _ in nil }, ifRight: { $0 })
    }
    
}

// MARK: Convenience initializers

extension EitherType where LeftType == Void {
    
    public init() {
        self.init(left: ())
    }
    
}

extension EitherType where RightType == Void {
    
    public init() {
        self.init(right: ())
    }
    
}

// MARK: Either equatability

extension EitherType {
    
    public func equals<OtherEither: EitherType>(_ other: OtherEither, leftEqual: (LeftType, OtherEither.LeftType) -> Bool, rightEqual: (RightType, OtherEither.RightType) -> Bool) -> Bool {
        return analysis(ifLeft: { lhsLeft in
            other.analysis(ifLeft: { rhsLeft in
                leftEqual(lhsLeft, rhsLeft)
            }, ifRight: { _ in false })
        }, ifRight: { lhsRight in
            other.analysis(ifLeft: { _ in false }, ifRight: { rhsRight in
                rightEqual(lhsRight, rhsRight)
            })
        })
    }
    
}

public func ==<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType: Equatable, LeftEither.RightType: Equatable, RightEither.LeftType == LeftEither.LeftType, RightEither.RightType == LeftEither.RightType {
    return lhs.equals(rhs, leftEqual: ==, rightEqual: ==)
}

public func !=<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType: Equatable, LeftEither.RightType: Equatable, RightEither.LeftType == LeftEither.LeftType, RightEither.RightType == LeftEither.RightType {
    return !(lhs == rhs)
}

public func ==<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType == Void, RightEither.LeftType == Void, LeftEither.RightType: Equatable, RightEither.RightType == LeftEither.RightType {
    return lhs.equals(rhs, leftEqual: { _ in true }, rightEqual: ==)
}

public func !=<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType == Void, RightEither.LeftType == Void, LeftEither.RightType: Equatable, RightEither.RightType == LeftEither.RightType {
    return !(lhs == rhs)
}

public func ==<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType: Equatable, RightEither.LeftType == LeftEither.LeftType, LeftEither.RightType == Void, RightEither.RightType == Void {
    return lhs.equals(rhs, leftEqual: ==, rightEqual: { _ in true })
}

public func !=<LeftEither: EitherType, RightEither: EitherType>(lhs: LeftEither, rhs: RightEither) -> Bool where LeftEither.LeftType: Equatable, RightEither.LeftType == LeftEither.LeftType, LeftEither.RightType == Void, RightEither.RightType == Void {
    return !(lhs == rhs)
}
