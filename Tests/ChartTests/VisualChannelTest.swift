//
//  VisualChannelTest.swift
//
//
//  Created by Joseph Heck on 4/6/22.
//

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
}
