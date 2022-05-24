//
//  MarkTests.swift
//

@testable import Chart
import XCTest

class MarkTests: XCTestCase {
    lazy var sampleData: [TestSampleData] = {
        let range: ClosedRange<Int> = 0 ... 100
        return range.map { num in
            TestSampleData(x: Double(num) / 5, y: sin(Double(num) / 5))
        }
    }()

    func testPointMark() throws {
        let mark = PointMark(data: sampleData,
                             x: QuantitativeVisualChannel(\.xValue),
                             y: QuantitativeVisualChannel(\.yValue))
        XCTAssertNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)
        XCTAssertEqual(mark.data, sampleData)
        XCTAssertEqual(mark.x.scale.scaleType, .linear)
        XCTAssertEqual(mark.x.scale.domainLower, 0)
        XCTAssertEqual(mark.x.scale.domainHigher, 20)
        XCTAssertEqual(mark.y.scale.scaleType, .linear)
        XCTAssertEqual(mark.y.scale.domainLower, -1)
        XCTAssertEqual(mark.y.scale.domainHigher, 1)
    }

    func testAnyMarkWrapper() throws {
        let mark = AnyMark(PointMark(data: sampleData,
                                     x: QuantitativeVisualChannel(\.xValue),
                                     y: QuantitativeVisualChannel(\.yValue)))
        XCTAssertNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)
        let reference = CGRect(x: 0, y: 0, width: 100, height: 50)
        let symbols = mark.symbolsForMark(in: reference)
        XCTAssertEqual(symbols.count, sampleData.count)
        let axisList = mark.axisForMark(in: reference)
        XCTAssertEqual(axisList.count, 0)
    }

    func testPointMarkWithXAxis() throws {
        let mark = PointMark(data: sampleData,
                             x: QuantitativeVisualChannel(\.xValue),
                             y: QuantitativeVisualChannel(\.yValue)).xAxis()
        XCTAssertNotNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)
        XCTAssertEqual(mark.data, sampleData)
        XCTAssertEqual(mark.x.scale.scaleType, .linear)
        XCTAssertEqual(mark.x.scale.domainLower, 0)
        XCTAssertEqual(mark.x.scale.domainHigher, 20)
        XCTAssertEqual(mark.y.scale.scaleType, .linear)
        XCTAssertEqual(mark.y.scale.domainLower, -1)
        XCTAssertEqual(mark.y.scale.domainHigher, 1)
    }

    func testAnyMarkWrapperWithXAxis() throws {
        let mark = AnyMark(PointMark(data: sampleData,
                                     x: QuantitativeVisualChannel(\.xValue),
                                     y: QuantitativeVisualChannel(\.yValue)).xAxis())
        XCTAssertNotNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)
        let reference = CGRect(x: 0, y: 0, width: 100, height: 50)
        let symbols = mark.symbolsForMark(in: reference)
        XCTAssertEqual(symbols.count, sampleData.count)
        let axisList = mark.axisForMark(in: reference)
        XCTAssertEqual(axisList.count, 1)
    }
}
