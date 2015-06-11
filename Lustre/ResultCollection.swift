//
//  Partition.swift
//  Lustre
//
//  Created by John Gallagher on 9/12/14.
//  Copyright © 2014-2015 Big Nerd Ranch Inc. Licensed under MIT.
//

public extension SequenceType where Generator.Element: ResultType {
    
    typealias Value = Generator.Element.Value
    typealias Error = Generator.Element.Error
    
    func partition() -> ([Value], [Error]) {
        var successes = [Value]()
        var failures = [Error]()
        
        for result in self {
            result.analysis(ifSuccess: {
                successes.append($0)
            }, ifFailure: {
                failures.append($0)
            })
        }
        
        return (successes, failures)
    }
    
    /// A function to collect `Result` instances into an array of `T` in the `.Success` case.
    ///
    /// - returns: A `Result<[T]>` such that all successes are collected within an array of the `.Success` case.
    func collectAllSuccesses() -> Result<[Value], Error> {
        var successes = [Value]()
        successes.reserveCapacity(underestimateCount())
        
        for result in self {
            if let error = result.analysis(ifSuccess: { (v: Value) -> Error? in
                successes.append(v)
                return nil
            }, ifFailure: { .Some($0) }) {
                return failure(error)
            }
        }
        
        return success(successes)
    }
    
}

public extension ResultType where Value: SequenceType {
    
    typealias Element = Value.Generator.Element
    
    /// Breaks a `Result` with collection into arrays of `successes` and `failures`.
    ///
    /// - parameter transform: The function to be used to create the array given to the `successes` member of the tuple.
    ///
    /// - returns: A tuple of `successes` and `failures`.
    public func split<Result: ResultType>(@noescape transform: Element -> Result) -> Lustre.Result<(successes: [Result.Value], failures: [Result.Error]), Error> {
        return map {
            lazy($0).map(transform).partition()
        }
    }
    
}
