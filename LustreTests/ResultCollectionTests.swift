//
//  ResultCollectionTests.swift
//  Lustre
//
//  Created by Zachary Waldowski on 6/11/15.
//  Copyright © 2015 Zachary Waldowski. All rights reserved.
//

import XCTest
import Lustre

class ResultCollectionTests: XCTestCase {
    
    private let testWithFailure = [ success(-1), success(0), success(1), failure(Error.First) ] as [Result<Int, Error>]
    private let testAllSuccesses = [ success(-1), success(0), success(1), success(2) ] as [Result<Int, Error>]
    
    func testPartition() {
        let (successes, failures) = testWithFailure.partition()
        
        XCTAssertEqual(Set(successes), [ -1, 0, 1 ])
        XCTAssertEqual(Set(failures), [ Error.First ])
    }
    
    func testCollectSuccess() {
        testAllSuccesses.collectAllSuccesses().analysis(ifSuccess: {
            XCTAssertEqual(Set($0), [ -1, 0, 1, 2 ])
        }, ifFailure: {
            XCTFail("Unexpected failure: \($0)")
        })
    }
    
    func testCollectFailure() {
        testWithFailure.collectAllSuccesses().analysis(ifSuccess: {
            XCTFail("Unexpected success: \($0)")
        }, ifFailure: { _ in })
    }
    
    func testSplit() {
        let arrayResult = success([-1, 0, 1, 2]) as Result<[Int], Error>
        let splitResult = arrayResult.split { (number: Int) -> Result<Int, Error> in
            if number >= 0 {
                return success(number * 2)
            } else {
                return failure(Error.First)
            }
        }
        
        splitResult.analysis(ifSuccess: {
            XCTAssertEqual(Set($0.0), [ 0, 2, 4 ])
            XCTAssert($0.1.count == 1)
        }, ifFailure: {
            XCTFail("Unexpected failure: \($0)")
        })
    }

}
