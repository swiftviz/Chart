//
//  DotMarkTests.swift
//

import Chart
import XCTest

class DotMarkTests: XCTestCase {
    func testDotMarkInitializer() throws {
        let x = PointMark(data: [TestSampleData(x: 2, y: 3)],
                          x: QuantitativeVisualChannel(\.xValue),
                          y: QuantitativeVisualChannel(167))
        XCTAssertNotNil(x)
    }
}
