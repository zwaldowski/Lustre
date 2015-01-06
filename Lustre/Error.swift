//
//  Error.swift
//  URLGrey
//
//  Created by Zachary Waldowski on 12/10/14.
//  Copyright (c) 2014 Zachary Waldowski. All rights reserved.
//

import Foundation

public protocol ErrorRepresentable {
    typealias ErrorCode: SignedIntegerType

    class var domain: String { get }
    var code: ErrorCode { get }
    var localizedDescription: String? { get }
}

public func error<T: ErrorRepresentable>(#code: T) -> NSError {
    var userInfo = [NSObject: AnyObject]()
    if let description = code.localizedDescription {
        userInfo[NSLocalizedDescriptionKey] = description
    }
    return NSError(domain: T.domain, code: numericCast(code.code), userInfo: userInfo)
}
