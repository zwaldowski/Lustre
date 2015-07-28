//
//  SequenceType+Result.swift
//  Lustre
//
//  Created by John Gallagher on 9/12/14.
//  Copyright © 2014-2015 Big Nerd Ranch Inc. Licensed under MIT.
//

extension SequenceType where Generator.Element: EitherType, Generator.Element.LeftType == ErrorType  {
    
    private typealias Value = Generator.Element.RightType
    
    public func partition() -> ([ErrorType], [Value]) {
        var lefts  = [ErrorType]()
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
        successes.reserveCapacity(underestimateCount())
        
        for result in self {
            successes.append(try result.extract())
        }
        
        return successes
    }
    
    public func collectAllSuccesses() -> Result<[Value]> {
        do {
            return .Success(try extractAll())
        } catch {
            return .Failure(error)
        }
    }
    
}

extension EitherType where LeftType == ErrorType, RightType: SequenceType {
    
    private typealias Element = RightType.Generator.Element
    
    public func split<NewValue>(@noescape transform: Element -> Result<NewValue>) -> Result<([ErrorType], [NewValue])> {
        return map {
            lazy($0).map(transform).partition()
        }
    }
    
}
