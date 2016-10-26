//
//  SequenceType+Result.swift
//  Lustre
//
//  Created by John Gallagher on 9/12/14.
//  Copyright © 2014-2015 Big Nerd Ranch Inc. Licensed under MIT.
//

extension Sequence where Iterator.Element: EitherType, Iterator.Element.LeftType == Error  {
    
    fileprivate typealias Value = Iterator.Element.RightType
    
    public func partition() -> ([Error], [Value]) {
        var lefts  = [Error]()
        var rights = [Value]()
        
        for either in self {
            either.analysis(ifLeft: {
                lefts.append($0)
            }, ifRight: {
                rights.append($0)
            })
        }
        
        return (lefts, rights)
    }
    
    
    public func extractAll() throws -> [Value] {
        var successes = [Value]()
        successes.reserveCapacity(underestimatedCount)
        
        for result in self {
            successes.append(try result.extract())
        }
        
        return successes
    }
    
    public func collectAllSuccesses() -> Result<[Value]> {
        do {
            return .success(try extractAll())
        } catch {
            return .failure(error)
        }
    }
    
}

extension EitherType where LeftType == Error, RightType: Sequence {
    
    fileprivate typealias Element = RightType.Iterator.Element
    
    public func split<NewValue>(_ transform: @escaping (Element) -> Result<NewValue>) -> Result<([Error], [NewValue])> {
        return map {
            $0.lazy.map(transform).partition()
        }
    }
    
}
