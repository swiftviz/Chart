//
//  VisualPropertyScaleTests.swift
//
//
//  Created by Joseph Heck on 5/24/22.
//

@testable import Chart
import SwiftVizScale
import XCTest

class VisualPropertyScaleTests: XCTestCase {
    func testContinousScaleTicksDefault() throws {
        let linear = VisualPropertyScale.continuous(AnyContinuousScale(LinearScale<Double, CGFloat>().domain(lower: 0, higher: 23)))
        let labels = linear.tickLabels()

        XCTAssertEqual(labels, ["0.0", "5.0", "10.0", "15.0", "20.0", "25.0"])

        let ticks = linear.tickValuesFromScale(lower: 0, higher: 50)
        XCTAssertEqual(ticks.count, 5)
        XCTAssertEqual(ticks[0].rangeLocation, 0)
        XCTAssertEqual(ticks[4].rangeLocation, 43.478, accuracy: 0.01)
    }

    func testContinousScaleTicksProvided() throws {
        let linear = VisualPropertyScale.continuous(AnyContinuousScale(LinearScale<Double, CGFloat>().domain(lower: 0, higher: 23)))
        let labels = linear.tickLabels(values: [10, 20, 30])

        XCTAssertEqual(labels, ["10.0", "20.0"])

        let ticks = linear.tickValuesFromScale(lower: 0, higher: 50, values: [10, 20, 30])
        XCTAssertEqual(ticks.count, 2)
        XCTAssertEqual(ticks[0].label, "10.0")
        XCTAssertEqual(ticks[0].rangeLocation, 21.739, accuracy: 0.01)
        XCTAssertEqual(ticks[1].label, "20.0")
        XCTAssertEqual(ticks[1].rangeLocation, 43.478, accuracy: 0.01)
    }

    func testBandScaleTicksDefault() throws {
        let band = VisualPropertyScale.band(BandScale<String, CGFloat>().domain(["A", "B"]))
        let labels = band.tickLabels()

        XCTAssertEqual(labels, ["A", "B"])

        let ticks = band.tickValuesFromScale(lower: 0, higher: 50)
        XCTAssertEqual(ticks.count, 2)
        XCTAssertEqual(ticks[0].rangeLocation, 12.5)
        XCTAssertEqual(ticks[1].rangeLocation, 37.5)
    }

    func testBandScaleTicksProvided() throws {
        let band = VisualPropertyScale.band(BandScale<String, CGFloat>().domain(["A", "B"]))
        let labels = band.tickLabels(values: [0, 1, 2, 3])
        // values is a no-op with band or point
        XCTAssertEqual(labels, ["A", "B"])

        let ticks = band.tickValuesFromScale(lower: 0, higher: 50, values: [0, 1, 2, 3])
        XCTAssertEqual(ticks.count, 2)
        XCTAssertEqual(ticks[0].rangeLocation, 12.5)
        XCTAssertEqual(ticks[1].rangeLocation, 37.5)
    }

    func testPointScaleTicksDefault() throws {
        let band = VisualPropertyScale.point(PointScale<String, CGFloat>().domain(["A", "B"]))
        let labels = band.tickLabels()

        XCTAssertEqual(labels, ["A", "B"])

        let ticks = band.tickValuesFromScale(lower: 0, higher: 50)
        XCTAssertEqual(ticks.count, 2)
        XCTAssertEqual(ticks[0].rangeLocation, 12.5)
        XCTAssertEqual(ticks[1].rangeLocation, 37.5)
    }

    func testPointScaleTicksProvided() throws {
        let band = VisualPropertyScale.point(PointScale<String, CGFloat>().domain(["A", "B"]))
        let labels = band.tickLabels(values: [0, 1, 2, 3])
        // values is a no-op with band or point
        XCTAssertEqual(labels, ["A", "B"])

        let ticks = band.tickValuesFromScale(lower: 0, higher: 50, values: [0, 1, 2, 3])
        XCTAssertEqual(ticks.count, 2)
        XCTAssertEqual(ticks[0].rangeLocation, 12.5)
        XCTAssertEqual(ticks[1].rangeLocation, 37.5)
    }
}
