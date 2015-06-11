//
//  Optional.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2015 Zachary Waldowski. All rights reserved.
//

public enum NoError: ErrorType, Equatable {
    case Unit
}

public func ==(lhs: NoError, rhs: NoError) -> Bool { return true }

extension Optional: ResultType {
    
    public init(failure: NoError) {
        self = .None
    }
    
    public func analysis<R>(@noescape ifSuccess ifSuccess: T -> R, @noescape ifFailure: NoError -> R) -> R {
        switch self {
        case .Some(let value): return ifSuccess(value)
        case .None: return ifFailure(.Unit)
        }
    }
    
}

public func failure<Result: ResultType where Result.Error == NoError>() -> Result {
    return Result(failure: .Unit)
}
