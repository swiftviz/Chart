//
//  MarkAxisTests.swift
//  

@testable import Chart
import XCTest

class MarkAxisTests: XCTestCase {

    lazy var sampleData: [TestSampleData] = {
        let range: ClosedRange<Int> = 0 ... 100
        return range.map { num in
            TestSampleData(x: Double(num)/5, y: sin(Double(num)/5))
        }
    }()

    func testXAxisMark() throws {
        let mark = PointMark(data: self.sampleData,
                             x: QuantitativeVisualChannel(\.xValue),
                             y: QuantitativeVisualChannel(\.yValue))
            .xAxis()
        XCTAssertNotNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)
        XCTAssertEqual(mark._xAxis?.rule, true)
    }

    func testXAxisSpec() throws {
        let chart = Chart {
            PointMark(data: self.sampleData,
                      x: QuantitativeVisualChannel(\.xValue),
                      y: QuantitativeVisualChannel(\.yValue))
                .xAxis()
        }
        XCTAssertNotNil(chart)
        XCTAssertEqual(chart.specCollection.marks.count, 1)
        let mark = chart.specCollection.marks.first!
        XCTAssertNotNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)
    }

}
