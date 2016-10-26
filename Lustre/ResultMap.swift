//
//  ResultMapping.swift
//  BNRSwiftJSON
//
//  Created by John Gallagher on 6/3/15.
//  Copyright © 2014-2015 Big Nerd Ranch Inc. Licensed under MIT.
//

public func mapAll<V, E0: EitherType, E1: EitherType>(_ e0: E0, _ e1: E1, transform: @escaping (E0.RightType, E1.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error {
    return e0.flatMap { s0 in
        e1.map { transform(s0, $0) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, transform: @escaping (E0.RightType, E1.RightType, E2.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2) { transform(s0, $0, $1) }
    }
}


public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3) { transform(s0, $0, $1, $2) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4) { transform(s0, $0, $1, $2, $3) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5) { transform(s0, $0, $1, $2, $3, $4) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6) { transform(s0, $0, $1, $2, $3, $4, $5) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7) { transform(s0, $0, $1, $2, $3, $4, $5, $6) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error, E10.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error, E10.LeftType == Error, E11.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error, E10.LeftType == Error, E11.LeftType == Error, E12.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType, E13: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, _ e13: E13, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType, E13.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error, E10.LeftType == Error, E11.LeftType == Error, E12.LeftType == Error, E13.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType, E13: EitherType, E14: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, _ e13: E13, _ e14: E14, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType, E13.RightType, E14.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error, E10.LeftType == Error, E11.LeftType == Error, E12.LeftType == Error, E13.LeftType == Error, E14.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) }
    }
}

public func mapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType, E13: EitherType, E14: EitherType, E15: EitherType>(_ e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, _ e13: E13, _ e14: E14, _ e15: E15, transform: @escaping (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType, E13.RightType, E14.RightType, E15.RightType) -> V) -> Result<V> where E0.LeftType == Error, E1.LeftType == Error, E2.LeftType == Error, E3.LeftType == Error, E4.LeftType == Error, E5.LeftType == Error, E6.LeftType == Error, E7.LeftType == Error, E8.LeftType == Error, E9.LeftType == Error, E10.LeftType == Error, E11.LeftType == Error, E12.LeftType == Error, E13.LeftType == Error, E14.LeftType == Error, E15.LeftType == Error {
    return e0.flatMap { s0 in
        mapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) }
    }
}
