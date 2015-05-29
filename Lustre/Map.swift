//
//  Map.swift
//  Lustre
//
//  Created by Zachary Waldowski on 5/8/15.
//  Copyright (c) 2015 Zachary Waldowski. All rights reserved.
//

import Foundation

/// Returns a new Result by mapping success cases using `transform`, or
/// re-wrapping the error.
public func map<InResult: _ResultType, OutResult: _ResultType>(result: InResult, @noescape transform: InResult.Value -> OutResult.Value) -> OutResult {
    return flatMap(result) { success(transform($0)) }
}

/// Returns a new Result by mapping success cases using `transform`, or
/// re-wrapping the error.
public func map<IR: ResultType, U>(result: IR, @noescape transform: IR.Value -> U) -> Result<U> {
    return result.map(transform)
}
