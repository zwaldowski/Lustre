//
//  NSError.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/10/15.
//  Copyright © 2014-2015. All rights reserved.
//

import Foundation

public extension ResultType {
    
    /// Returns the Result of mapping `transform` over `self`.
    public func flatMap<Result: ResultType where Result.Error == NSError>(@noescape transform: Value -> Result) -> Result {
        return analysis(ifSuccess: transform, ifFailure: {
            Result(failure: $0)
        })
    }
    
}

public extension ResultType where Error == NSError {
    
    public init<Error: ErrorType>(failure: Error) {
        self.init(failure: failure as NSError)
    }
    
}

/// A failure result type returning a given error.
public func failure<Result: ResultType, Error: ErrorType where Result.Error == NSError>(error: Error) -> Result {
    return Result(failure: error)
}
