//
//  Error.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 12/10/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public protocol ErrorRepresentable: Printable {
    typealias ErrorCode: SignedIntegerType

    class var domain: String { get }
    var code: ErrorCode { get }
    var failureReason: String? { get }
}

public func error<T: ErrorRepresentable>(#code: T, underlying: NSError? = nil) -> NSError {
    var userInfo = [NSObject: AnyObject]()

    userInfo[NSLocalizedDescriptionKey] = code.description

    if let reason = code.failureReason {
        userInfo[NSLocalizedFailureReasonErrorKey] = reason
    }

    if let underlying = underlying {
        userInfo[NSUnderlyingErrorKey] = underlying
    }

    return NSError(domain: T.domain, code: numericCast(code.code), userInfo: userInfo)
}
