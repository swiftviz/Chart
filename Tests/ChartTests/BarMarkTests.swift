//
//  BarMarkTests.swift
//

import Chart
import XCTest

class BarMarkTests: XCTestCase {
    struct SampleData {
        let name: String
        let value: Double
    }

    func testBarMarkInitializer() throws {
        let x = BarMark(data: [SampleData(name: "X", value: 1)],
                        value: QuantitativeVisualChannel(\.value),
                        category: BandVisualChannel(\.name))
        XCTAssertNotNil(x)
    }
}
