//
//  Optional.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2014-2015. Some rights reserved.
//

extension Optional: EitherType {
    
    public init(left: Void) {
        self = .none
    }
    
    public init(right: Wrapped) {
        self = .some(right)
    }
    
    public func analysis<Result>(ifLeft: (Void) -> Result, ifRight: (Wrapped) -> Result) -> Result {
        switch self {
        case .none: return ifLeft()
        case .some(let value): return ifRight(value)
        }
    }
    
}
