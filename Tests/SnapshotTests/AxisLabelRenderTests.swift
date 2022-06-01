//
//  AxisLabelRenderTests.swift
//

import Chart
import SnapshotTesting
import SwiftUI
import XCTest

final class AxisLabelRenderTests: XCTestCase {
    struct SampleData {
        let xValue: Double
        let yValue: Double
    }

    let data: [SampleData] = [
        SampleData(xValue: 2, yValue: 3),
        SampleData(xValue: 3, yValue: 5),
        SampleData(xValue: 4, yValue: 2),
        SampleData(xValue: 5, yValue: 7),
    ]

    #if os(macOS)
        func testBottomXAxis_0offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis lable", labelOffset: 0, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_0offset_leading() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis lable", labelOffset: 0, labelAlignment: .leading)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_0offset_trailing() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis lable", labelOffset: 0, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_10offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis lable", labelOffset: 10, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_10offset_leading() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis lable", labelOffset: 10, labelAlignment: .leading)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_10offset_trailing() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis lable", labelOffset: 10, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }
    #endif
}
