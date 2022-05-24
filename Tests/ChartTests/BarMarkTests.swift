//
//  BarMarkTests.swift
//

import Chart
import XCTest

class BarMarkTests: XCTestCase {
    func testBarMarkInitializer() throws {
        let x = BarMark(data: [TestSampleData(name: "X", intValue: 1)],
                        value: QuantitativeVisualChannel(\.value),
                        category: BandVisualChannel(\.name))
        XCTAssertNotNil(x)
    }
}
