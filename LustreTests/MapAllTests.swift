//
//  MapAllTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import Lustre

class MapAllTests: XCTestCase {
    
    fileprivate let aValue  = 42
    fileprivate let anError = Error.first
    
    fileprivate let aSuccessResult = Result<Int>.success(42)
    fileprivate let aFailureResult = Result<Int>.failure(Error.first)
    
    fileprivate func makeSuccess(_ i: Int) -> Result<Int> {
        return aSuccessResult.map { $0 + i }
    }
    
    fileprivate struct IncrediblyContrived: Equatable {
        
        static func create(_ first: Int, second: Int, third: Int, fourth: Int, fifth: Int, sixth: Int, seventh: Int, eighth: Int, ninth: Int, tenth: Int, eleventh: Int, twelfth: Int, thirteenth: Int, fourteenth: Int, fifteenth: Int, sixteenth: Int) -> Result<IncrediblyContrived> {
            return Result.success(IncrediblyContrived(first: first, second: second, third: third, fourth: fourth, fifth: fifth, sixth: sixth, seventh: seventh, eighth: eighth, ninth: ninth, tenth: tenth, eleventh: eleventh, twelfth: twelfth, thirteenth: thirteenth, fourteenth: fourteenth, fifteenth: fifteenth, sixteenth: sixteenth))
        }
        
        let first     : Int
        let second    : Int
        let third     : Int
        let fourth    : Int
        let fifth     : Int
        let sixth     : Int
        let seventh   : Int
        let eighth    : Int
        let ninth     : Int
        let tenth     : Int
        let eleventh  : Int
        let twelfth   : Int
        let thirteenth: Int
        let fourteenth: Int
        let fifteenth : Int
        let sixteenth : Int
    }
    
    fileprivate let aComposite = IncrediblyContrived(first: 42, second: 43, third: 44, fourth: 45, fifth: 46, sixth: 47, seventh: 48, eighth: 49, ninth: 50, tenth: 51, eleventh: 52, twelfth: 53, thirteenth: 54, fourteenth: 55, fifteenth: 56, sixteenth: 57)
    
    
    func testMapSuccess() {
        let first      = makeSuccess(0)
        let second     = makeSuccess(1)
        let third      = makeSuccess(2)
        let fourth     = makeSuccess(3)
        let fifth      = makeSuccess(4)
        let sixth      = makeSuccess(5)
        let seventh    = makeSuccess(6)
        let eighth     = makeSuccess(7)
        let ninth      = makeSuccess(8)
        let tenth      = makeSuccess(9)
        let eleventh   = makeSuccess(10)
        let twelfth    = makeSuccess(11)
        let thirteenth = makeSuccess(12)
        let fourteenth = makeSuccess(13)
        let fifteenth  = makeSuccess(14)
        let sixteenth  = makeSuccess(15)
        
        let final = mapAll(first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelfth, thirteenth, fourteenth, fifteenth, sixteenth, transform: IncrediblyContrived.init)
        
        assertSuccess(final, aComposite)
    }
    
    func testMapAllFailure() {
        let first      = makeSuccess(0)
        let second     = makeSuccess(1)
        let third      = makeSuccess(2)
        let fourth     = makeSuccess(3)
        let fifth      = makeSuccess(4)
        let sixth      = makeSuccess(5)
        let seventh    = makeSuccess(6)
        let eighth     = makeSuccess(7)
        let ninth      = makeSuccess(8)
        let tenth      = makeSuccess(9)
        let eleventh   = makeSuccess(10)
        let twelfth    = makeSuccess(11)
        let thirteenth = makeSuccess(12)
        let fourteenth = makeSuccess(13)
        let fifteenth  = makeSuccess(14)
        let sixteenth  = aFailureResult
        
        let final = mapAll(first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelfth, thirteenth, fourteenth, fifteenth, sixteenth, transform: IncrediblyContrived.init)
        
        assertFailure(final, anError)
    }
    
    func testFlatMapSuccess() {
        let first      = makeSuccess(0)
        let second     = makeSuccess(1)
        let third      = makeSuccess(2)
        let fourth     = makeSuccess(3)
        let fifth      = makeSuccess(4)
        let sixth      = makeSuccess(5)
        let seventh    = makeSuccess(6)
        let eighth     = makeSuccess(7)
        let ninth      = makeSuccess(8)
        let tenth      = makeSuccess(9)
        let eleventh   = makeSuccess(10)
        let twelfth    = makeSuccess(11)
        let thirteenth = makeSuccess(12)
        let fourteenth = makeSuccess(13)
        let fifteenth  = makeSuccess(14)
        let sixteenth  = makeSuccess(15)

        let final = flatMapAll(first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelfth, thirteenth, fourteenth, fifteenth, sixteenth, transform: IncrediblyContrived.create)
        
        assertSuccess(final, aComposite)
    }
    
    
    func testFlatMapAllFailure() {
        let first      = makeSuccess(0)
        let second     = makeSuccess(1)
        let third      = makeSuccess(2)
        let fourth     = makeSuccess(3)
        let fifth      = makeSuccess(4)
        let sixth      = makeSuccess(5)
        let seventh    = makeSuccess(6)
        let eighth     = makeSuccess(7)
        let ninth      = makeSuccess(8)
        let tenth      = makeSuccess(9)
        let eleventh   = makeSuccess(10)
        let twelfth    = makeSuccess(11)
        let thirteenth = makeSuccess(12)
        let fourteenth = makeSuccess(13)
        let fifteenth  = makeSuccess(14)
        let sixteenth  = aFailureResult
        
        let final = flatMapAll(first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth, eleventh, twelfth, thirteenth, fourteenth, fifteenth, sixteenth, transform: IncrediblyContrived.create)

        assertFailure(final, anError)
    }
    
}

private func ==(lhs: MapAllTests.IncrediblyContrived, rhs: MapAllTests.IncrediblyContrived) -> Bool {
    return lhs.first   == rhs.first      &&
        lhs.second     == rhs.second     &&
        lhs.third      == rhs.third      &&
        lhs.fourth     == rhs.fourth     &&
        lhs.fifth      == rhs.fifth      &&
        lhs.sixth      == rhs.sixth      &&
        lhs.seventh    == rhs.seventh    &&
        lhs.eighth     == rhs.eighth     &&
        lhs.ninth      == rhs.ninth      &&
        lhs.tenth      == rhs.tenth      &&
        lhs.eleventh   == rhs.eleventh   &&
        lhs.twelfth    == rhs.twelfth    &&
        lhs.thirteenth == rhs.thirteenth &&
        lhs.fourteenth == rhs.fourteenth &&
        lhs.fifteenth  == rhs.fifteenth  &&
        lhs.sixteenth  == rhs.sixteenth
}
