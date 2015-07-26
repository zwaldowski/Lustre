//
//  Optional.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2014-2015. Some rights reserved.
//

extension Optional: EitherType {
    
    public init(left: Void) {
        self = .None
    }
    
    public init(right: T) {
        self = .Some(right)
    }
    
    public func analysis<Result>(@noescape ifLeft ifLeft: Void -> Result, @noescape ifRight: T -> Result) -> Result {
        switch self {
        case .None: return ifLeft()
        case .Some(let value): return ifRight(value)
        }
    }
    
}
