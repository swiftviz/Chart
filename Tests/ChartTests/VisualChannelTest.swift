//
//  VisualChannelTest.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Chart
import XCTest

class VisualChannelTest: XCTestCase {
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

    let data = SampleData("X", 3, Double.pi, 5.0)

    func testQuantitativeChannelConstant() throws {
        let intChannel = QuantitativeVisualChannel<SampleData>(\.value)
        XCTAssertNotNil(intChannel)
        let doubleChannel = QuantitativeVisualChannel<SampleData>(\.xValue)
        XCTAssertNotNil(doubleChannel)
    }
}
