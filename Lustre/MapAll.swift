//
//  MapAll.swift
//  Lustre
//
//  Created by John Gallagher on 9/12/14.
//  Copyright © 2014-2015 Big Nerd Ranch Inc. Licensed under MIT.
//

import Foundation

/**
A function to `map` the `Result` value into a function call.

- parameter r1: The `Result`.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, U>(r1: R1, @noescape f: (R1.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { success(f($0)) }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r2: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, U>(r1: R1, r2: R2, @noescape f: (R1.Value, R2.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2) { f(s1, $0) }
    }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r3: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, R3: ResultType, U>(r1: R1, r2: R2, r3: R3, @noescape f: (R1.Value, R2.Value, R3.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2, r2: r3) { f(s1, $0, $1) }
    }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r4: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, U>(r1: R1, r2: R2, r3: R3, r4: R4, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2, r2: r3, r3: r4) { f(s1, $0, $1, $2) }
    }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r5: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, U>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2, r2: r3, r3: r4, r4: r5) { f(s1, $0, $1, $2, $3) }
    }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r6: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, R6: ResultType, U>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, r6: R6, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2, r2: r3, r3: r4, r4: r5, r5: r6) { f(s1, $0, $1, $2, $3, $4) }
    }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r7: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, R6: ResultType, R7: ResultType, U>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, r6: R6, r7: R7, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2, r2: r3, r3: r4, r4: r5, r5: r6, r6: r7) { f(s1, $0, $1, $2, $3, $4, $5) }
    }
}

/**
A function to `map` all of the `Result` values into a single function call.

- parameter r1...r8: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func mapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, R6: ResultType, R7: ResultType, R8: ResultType, U>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, r6: R6, r7: R7, r8: R8, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value, R8.Value) -> U) -> Result<U, NSError> {
    return r1.flatMap { s1 in
        mapAll(r2, r2: r3, r3: r4, r4: r5, r5: r6, r6: r7, r7: r8) { f(s1, $0, $1, $2, $3, $4, $5, $6) }
    }
}

/**
A function to `flatMap` the `Result` value into a function call.

- parameter r1: The `Result`.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, @noescape f: R1.Value -> Result) -> Result {
    return r1.flatMap(f)
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r2: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, @noescape f: (R1.Value, R2.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2) { f(s1, $0) }
    }
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r3: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, R3: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, r3: R3, @noescape f: (R1.Value, R2.Value, R3.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2, r2: r3) { f(s1, $0, $1) }
    }
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r4: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, r3: R3, r4: R4, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2, r2: r3, r3: r4) { f(s1, $0, $1, $2) }
    }
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r5: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2, r2: r3, r3: r4, r4: r5) { f(s1, $0, $1, $2, $3) }
    }
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r6: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, R6: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, r6: R6, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2, r2: r3, r3: r4, r4: r5, r5: r6) { f(s1, $0, $1, $2, $3, $4) }
    }
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r7: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, R6: ResultType, R7: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, r6: R6, r7: R7, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2, r2: r3, r3: r4, r4: r5, r5: r6, r6: r7) { f(s1, $0, $1, $2, $3, $4, $5) }
    }
}

/**
A function to `flatMap` all of the `Result` values into a single function call.

- parameter r1...r8: The `Result`s.
- parameter f: The function to call.

- returns: A `Result`.
*/
public func flatMapAll<R1: ResultType, R2: ResultType, R3: ResultType, R4: ResultType, R5: ResultType, R6: ResultType, R7: ResultType, R8: ResultType, Result: ResultType where Result.Error == NSError>(r1: R1, r2: R2, r3: R3, r4: R4, r5: R5, r6: R6, r7: R7, r8: R8, @noescape f: (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value, R8.Value) -> Result) -> Result {
    return r1.flatMap { s1 in
        flatMapAll(r2, r2: r3, r3: r4, r4: r5, r5: r6, r6: r7, r7: r8) { f(s1, $0, $1, $2, $3, $4, $5, $6) }
    }
}
