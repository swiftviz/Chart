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
        let name: String
        let value: Int
        let xValue: Double
        let yValue: Double

        init(_ name: String, _ intValue: Int, _ x: Double, _ y: Double) {
            self.name = name
            value = intValue
            xValue = x
            yValue = y
        }
    }

    let data = [
        SampleData("X", 3, Double.pi, 5.0),
        SampleData("Y", 4, Double.pi, 7.0),
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
