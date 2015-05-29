//
//  Partition.swift
//  Lustre
//
//  Created by John Gallagher on 9/12/14.
//  Copyright (c) 2015 Big Nerd Ranch Inc. Licensed under MIT.
//

public func partitionResults<InResult: ResultType, Seq: SequenceType where Seq.Generator.Element == InResult>(results: Seq) -> ([InResult.Value], [NSError]) {
    var successes = Array<InResult.Value>()
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

/**
    A function to collect `Result` instances into an array of `T` in the `.Success` case.

    :param: results Any sequence of `Result<T>`: `[Result<T>]`.

    :returns: A `Result<[T]>` such that all successes are collected within an array of the `.Success` case.
*/
public func collectAllSuccesses<InResult: ResultType, Seq: SequenceType where Seq.Generator.Element == InResult>(results: Seq) -> Result<[InResult.Value]> {
    var successes = Array<InResult.Value>()
    for result in results {
        if let error = result.analysis(ifSuccess: {
            successes.append($0)
            return nil
        }, ifFailure: { $0 }) {
            return failure(error)
        }
    }
    return success(successes)
}

/**
    A function to break a `Result` with an array of type `[U]` into a tuple of `successes` and `failures`.

    :param: result The `Result<[U]>`.
    :param: f The function to be used to create the array given to the `successes` member of the tuple.

    :returns: A tuple of `successes` and `failures`.
*/
public func splitResult<U, UResult: ResultType, TResult: ResultType where UResult.Value == [U]>(result: UResult, @noescape f: U -> TResult) -> Result<(successes: [TResult.Value], failures: [NSError])> {
    var successes = Array<TResult.Value>()
    var failures = [NSError]()
    
    return result.flatMap { results in
        for result in results {
            f(result).analysis(ifSuccess: {
                successes.append($0)
            }, ifFailure: {
                failures.append($0)
            })
        }
        return success((successes, failures))
    }
}
