//
//  BarMarkTests.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

import Chart
import XCTest

class BarMarkTests: XCTestCase {
    struct SampleData {
        let name: String
        let value: Int
    }

    func testBarMarkInitializer() throws {
        let x = BarMark(data: [SampleData(name: "X", value: 1)], 1, "z")
        XCTAssertNotNil(x)
    }
}
