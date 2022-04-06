//
//  DotMarkTests.swift
//  
//
//  Created by Joseph Heck on 4/6/22.
//

import XCTest
import Chart

class DotMarkTests: XCTestCase {

    struct SampleData {
        let xValue: Double
        let yValue: Double
    }
    
    func testDotMarkInitializer() throws {
        let x = DotMark(data: [SampleData(xValue: 2, yValue: 3)], x: .constant(ConstantVisualChannel(value: 3)))
        XCTAssertNotNil(x)
    }
}
