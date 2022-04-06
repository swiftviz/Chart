//
//  LineMarkTests.swift
//  
//
//  Created by Joseph Heck on 4/6/22.
//

import XCTest
import Chart

class LineMarkTests: XCTestCase {

    struct SampleData {
        let xValue: Double
        let yValue: Double
    }
    
    func testLineMarkInitializer() throws {
        let x = LineMark(data: [SampleData(xValue: 2, yValue: 3)])
        XCTAssertNotNil(x)
    }

}
