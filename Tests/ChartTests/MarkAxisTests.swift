//
//  MarkAxisTests.swift
//

@testable import Chart
import XCTest

class MarkAxisTests: XCTestCase {
    lazy var sampleData: [TestSampleData] = {
        let range: ClosedRange<Int> = 0 ... 100
        return range.map { num in
            TestSampleData(x: Double(num) / 5, y: sin(Double(num) / 5))
        }
    }()

    let reference = CGRect(x: 0, y: 0, width: 100, height: 50)

    func testXAxisMark() throws {
        let mark = PointMark(data: sampleData,
                             x: QuantitativeVisualChannel(\.xValue),
                             y: QuantitativeVisualChannel(\.yValue))
            .xAxis()
        XCTAssertNotNil(mark._xAxis)
        XCTAssertNil(mark._yAxis)

        let axis = mark._xAxis!
        // verifies default X Axis configuration values
        XCTAssertEqual(axis.rule, true)
        XCTAssertEqual(axis.axisLocation, .bottom)
        XCTAssertEqual(axis.label, "")
        switch axis.scale {
        case let .continuous(cont):
            XCTAssertEqual(cont.scaleType, .linear)
            XCTAssertEqual(cont.domainLower, 0)
            XCTAssertEqual(cont.domainHigher, 20)
        case .band:
            XCTFail()
        case .point:
            XCTFail()
        }
        XCTAssertEqual(axis.labelAlignment, .center)
        XCTAssertEqual(axis.labelOffset, 0)
        XCTAssertEqual(axis.tickLength, 3.0)
        XCTAssertEqual(axis.chartRules, false)
        XCTAssertEqual(axis.tickPadding, 5)
        XCTAssertEqual(axis.tickOrientation, .outer)
        XCTAssertEqual(axis.requestedTickValues, [])

        // Ticks for an axis directly attached to a mark won't have any values
        // since it needs a range to be provided (through the mark) to be calculated.
        XCTAssertEqual(axis.ticks.count, 0)
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

        let axis = mark._xAxis!
        XCTAssertEqual(axis.ticks.count, 0)

        let ticksFromAxis = axis.resolveTicks(reference)
        // calculated axis through the mark will have ticks associated with it
        // and based on the domain provided by the data.
        XCTAssertEqual(ticksFromAxis.count, 5)

        XCTAssertEqual(ticksFromAxis.first?.label, "0.0")
        XCTAssertEqual(ticksFromAxis.first?.rangeLocation, 0)
        XCTAssertEqual(ticksFromAxis.last?.label, "20.0")
        XCTAssertEqual(ticksFromAxis.last?.rangeLocation, 100)
    }

    func testYAxisSpec() throws {
        let chart = Chart {
            PointMark(data: self.sampleData,
                      x: QuantitativeVisualChannel(\.xValue),
                      y: QuantitativeVisualChannel(\.yValue))
                .yAxis()
        }
        XCTAssertNotNil(chart)
        XCTAssertEqual(chart.specCollection.marks.count, 1)
        let mark = chart.specCollection.marks.first!
        XCTAssertNil(mark._xAxis)
        XCTAssertNotNil(mark._yAxis)

        let axis = mark._yAxis!
        // as yet unconfigured since no range has been applied
        XCTAssertEqual(axis.ticks.count, 0)

        let ticksFromAxis = axis.resolveTicks(reference, invertX: false, invertY: true)
        // calculated axis through the mark will have ticks associated with it
        // and based on the domain provided by the data.
        XCTAssertEqual(ticksFromAxis.count, 5)

        XCTAssertEqual(ticksFromAxis.first?.label, "-1.0")
        XCTAssertEqual(ticksFromAxis.first?.rangeLocation, 50)
        XCTAssertEqual(ticksFromAxis.last?.label, "1.0")
        XCTAssertEqual(ticksFromAxis.last?.rangeLocation, 0)
    }
}
