//
//  ResultCollectionTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2014-2015. Some rights reserved.
//

import XCTest
@testable import Lustre

class ResultCollectionTests: XCTestCase {
    
    fileprivate let testWithFailure = [ Result(value: -1), Result(value: 0), Result(value: 1), Result(error: Error.first) ] as [Result<Int>]
    fileprivate let testAllSuccesses = [ Result(value: -1), Result(value: 0), Result(value: 1), Result(value: 2) ] as [Result<Int>]
    
    func testPartition() {
        let (failures, successes) = testWithFailure.partition()
        
        XCTAssertEqual(Set(successes), [ -1, 0, 1 ])
        XCTAssert(failures.elementsEqual(CollectionOfOne(Error.first), by: {
            $0.matches($1)
        }))
    }
    
    func testCollectThrow() {
        assertNoThrow(testAllSuccesses.extractAll, [ -1, 0, 1, 2 ])
    }
    
    func testCollectSuccess() {
        assertSuccess(testAllSuccesses.collectAllSuccesses(), [ -1, 0, 1, 2 ])
    }

    func testCollectFailure() {
        assertFailure(testWithFailure.collectAllSuccesses(), Error.first)
    }
    
    func testSplit() {
        let arrayResult = Result<[Int]>(value: [-1, 0, 1, 2])
        let splitResult = arrayResult.split { (number: Int) -> Result<Int> in
            if number >= 0 {
                return Result(value: number * 2)
            }
            return Result(error: Error.first)
        }
        
        assertSuccess(splitResult) {
            XCTAssert($0.0.count == 1)
            XCTAssertEqual(Set($0.1), [ 0, 2, 4 ])
        }
    }

}
