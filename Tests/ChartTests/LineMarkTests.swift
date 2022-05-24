//
//  LineMarkTests.swift
//

import Chart
import XCTest

class LineMarkTests: XCTestCase {
    let data = [
        TestSampleData(name: "X", intValue: 3, x: Double.pi, y: 5.0),
        TestSampleData(name: "Y", intValue: 4, x: Double.pi, y: 7.0),
    ]

    func testLineMarkInitializer() throws {
        let x = LineMark(data: data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
        XCTAssertNotNil(x)
    }

    func testDifferentLineMarkInitializer() throws {
        let x = LineMark(data: data,
                         x: QuantitativeVisualChannel(\.value),
                         y: QuantitativeVisualChannel(\.yValue))
        XCTAssertNotNil(x)
    }
}
