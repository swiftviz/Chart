//
//  LineMarkTests.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Chart
import XCTest

class LineMarkTests: XCTestCase {
    struct SampleData {
        let xValue: Double
        let yValue: Double
    }

    func testLineMarkInitializer() throws {
        let x = LineMark(data: [SampleData(xValue: 2, yValue: 3), SampleData(xValue: 3, yValue: 4)],
                         x: QuantitativeVisualChannel(\SampleData.xValue),
                         y: QuantitativeVisualChannel(\SampleData.yValue))
        XCTAssertNotNil(x)
    }
}
