//
//  ChartTests.swift
//

@testable import Chart
import SwiftUI
import XCTest

final class PublicChartTests: XCTestCase {
    func testTypeStubs() throws {
        let chart = Chart {
            BarMark(data: [TestSampleData(name: "X", intValue: 1)],
                    value: QuantitativeVisualChannel(1),
                    category: BandVisualChannel("Z"))
        }
        XCTAssertNotNil(chart)
        XCTAssertEqual(chart.specCollection.margin.top, 0)
        XCTAssertEqual(chart.specCollection.inset.top, 0)
    }

    func testChartMargin() throws {
        let chart = Chart(margin: .init(10)) {
            BarMark(data: [TestSampleData(name: "X", intValue: 1)],
                    value: QuantitativeVisualChannel(1),
                    category: BandVisualChannel("Z"))
        }
        XCTAssertNotNil(chart)
        XCTAssertEqual(chart.specCollection.margin.top, 10)
        XCTAssertEqual(chart.specCollection.margin.bottom, 10)
        XCTAssertEqual(chart.specCollection.margin.leading, 10)
        XCTAssertEqual(chart.specCollection.margin.trailing, 10)
        XCTAssertEqual(chart.specCollection.inset.top, 0)
        XCTAssertEqual(chart.specCollection.inset.bottom, 0)
        XCTAssertEqual(chart.specCollection.inset.leading, 0)
        XCTAssertEqual(chart.specCollection.inset.trailing, 0)
    }

    func testChartMarginModifierAddingMargin() throws {
        let chart = Chart(margin: .init(10)) {
            BarMark(data: [TestSampleData(name: "X", intValue: 1)],
                    value: QuantitativeVisualChannel(1),
                    category: BandVisualChannel("Z"))
        }
        .margin(.vertical, 7) // adds 7 to the margin of the chart on top and bottom

        XCTAssertNotNil(chart)
        XCTAssertEqual(chart.specCollection.margin.top, 17)
        XCTAssertEqual(chart.specCollection.margin.bottom, 17)
        XCTAssertEqual(chart.specCollection.margin.leading, 10)
        XCTAssertEqual(chart.specCollection.margin.trailing, 10)
        XCTAssertEqual(chart.specCollection.inset.top, 0)
        XCTAssertEqual(chart.specCollection.inset.bottom, 0)
        XCTAssertEqual(chart.specCollection.inset.leading, 0)
        XCTAssertEqual(chart.specCollection.inset.trailing, 0)
    }

    func testChartMarginModifierAddingInset() throws {
        let chart = Chart(margin: .init(10)) {
            BarMark(data: [TestSampleData(name: "X", intValue: 1)],
                    value: QuantitativeVisualChannel(1),
                    category: BandVisualChannel("Z"))
        }
        .inset(.horizontal, 7) // adds 7 to the inset of the chart on leading and trailing

        XCTAssertNotNil(chart)
        XCTAssertEqual(chart.specCollection.margin.top, 10)
        XCTAssertEqual(chart.specCollection.margin.bottom, 10)
        XCTAssertEqual(chart.specCollection.margin.leading, 10)
        XCTAssertEqual(chart.specCollection.margin.trailing, 10)
        XCTAssertEqual(chart.specCollection.inset.top, 0)
        XCTAssertEqual(chart.specCollection.inset.bottom, 0)
        XCTAssertEqual(chart.specCollection.inset.leading, 7)
        XCTAssertEqual(chart.specCollection.inset.trailing, 7)
    }
}
