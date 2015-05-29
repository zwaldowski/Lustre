//
//  Partition.swift
//  Lustre
//
//  Created by John Gallagher on 9/12/14.
//  Copyright (c) 2015 Big Nerd Ranch Inc. Licensed under MIT.
//

public func partitionResults<Result: ResultType, Seq: SequenceType where Seq.Generator.Element == Result>(results: Seq) -> ([Result.Value], [NSError]) {
    var successes = Array<Result.Value>()
    var failures = [NSError]()
    
    for result in results {
        result.analysis(ifSuccess: {
            successes.append($0)
        }, ifFailure: {
            failures.append($0)
        })
    }
    
    return (successes, failures)
}
