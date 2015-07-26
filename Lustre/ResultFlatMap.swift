//
//  ResultFlatMap.swift
//  Lustre
//
//  Created by John Gallagher on 6/3/15.
//  Copyright © 2014-2015 Big Nerd Ranch Inc. Licensed under MIT.
//

public func flatMapAll<V, E0: EitherType, E1: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType>(e0: E0, _ e1: E1, @noescape transform: (E0.RightType, E1.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        e1.flatMap { transform(s0, $0) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, @noescape transform: (E0.RightType, E1.RightType, E2.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2) { transform(s0, $0, $1) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3) { transform(s0, $0, $1, $2) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4) { transform(s0, $0, $1, $2, $3) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5) { transform(s0, $0, $1, $2, $3, $4) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6) { transform(s0, $0, $1, $2, $3, $4, $5) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7) { transform(s0, $0, $1, $2, $3, $4, $5, $6) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType, E10.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType, E10.LeftType == ErrorType, E11.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType, E10.LeftType == ErrorType, E11.LeftType == ErrorType, E12.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType, E13: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType, E10.LeftType == ErrorType, E11.LeftType == ErrorType, E12.LeftType == ErrorType, E13.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, _ e13: E13, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType, E13.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType, E13: EitherType, E14: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType, E10.LeftType == ErrorType, E11.LeftType == ErrorType, E12.LeftType == ErrorType, E13.LeftType == ErrorType, E14.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, _ e13: E13, _ e14: E14, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType, E13.RightType, E14.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13) }
    }
}

public func flatMapAll<V, E0: EitherType, E1: EitherType, E2: EitherType, E3: EitherType, E4: EitherType, E5: EitherType, E6: EitherType, E7: EitherType, E8: EitherType, E9: EitherType, E10: EitherType, E11: EitherType, E12: EitherType, E13: EitherType, E14: EitherType, E15: EitherType where E0.LeftType == ErrorType, E1.LeftType == ErrorType, E2.LeftType == ErrorType, E3.LeftType == ErrorType, E4.LeftType == ErrorType, E5.LeftType == ErrorType, E6.LeftType == ErrorType, E7.LeftType == ErrorType, E8.LeftType == ErrorType, E9.LeftType == ErrorType, E10.LeftType == ErrorType, E11.LeftType == ErrorType, E12.LeftType == ErrorType, E13.LeftType == ErrorType, E14.LeftType == ErrorType, E15.LeftType == ErrorType>(e0: E0, _ e1: E1, _ e2: E2, _ e3: E3, _ e4: E4, _ e5: E5, _ e6: E6, _ e7: E7, _ e8: E8, _ e9: E9, _ e10: E10, _ e11: E11, _ e12: E12, _ e13: E13, _ e14: E14, _ e15: E15, @noescape transform: (E0.RightType, E1.RightType, E2.RightType, E3.RightType, E4.RightType, E5.RightType, E6.RightType, E7.RightType, E8.RightType, E9.RightType, E10.RightType, E11.RightType, E12.RightType, E13.RightType, E14.RightType, E15.RightType) -> Result<V>) -> Result<V> {
    return e0.flatMap { s0 in
        flatMapAll(e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11, e12, e13, e14, e15) { transform(s0, $0, $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) }
    }
}
