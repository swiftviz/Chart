//
//  DotMarkTests.swift
//

import Chart
import XCTest

class DotMarkTests: XCTestCase {
    struct SampleData {
        let xValue: Double
        let yValue: Double
    }

    func testDotMarkInitializer() throws {
        let x = PointMark(data: [SampleData(xValue: 2, yValue: 3)],
                          x: QuantitativeVisualChannel(\.xValue),
                          y: QuantitativeVisualChannel(167))
        XCTAssertNotNil(x)
    }
}
