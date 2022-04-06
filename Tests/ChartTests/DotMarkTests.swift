//
//  DotMarkTests.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Chart
import XCTest

class DotMarkTests: XCTestCase {
    struct SampleData {
        let xValue: Double
        let yValue: Double
    }

    func testDotMarkInitializer() throws {
        let x = DotMark(data: [SampleData(xValue: 2, yValue: 3)], x: VisualChannel(3))
        XCTAssertNotNil(x)
    }
}
