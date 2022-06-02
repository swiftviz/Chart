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

        // MARK: Bottom X Axis Tests

        func testBottomXAxis_0offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, label: "X axis label", labelOffset: 0, labelAlignment: .center)
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
                    .xAxis(.bottom, label: "X axis label", labelOffset: 0, labelAlignment: .leading)
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
                    .xAxis(.bottom, label: "X axis label", labelOffset: 0, labelAlignment: .trailing)
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
                    .xAxis(.bottom, label: "X axis label", labelOffset: 10, labelAlignment: .center)
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
                    .xAxis(.bottom, label: "X axis label", labelOffset: 10, labelAlignment: .leading)
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
                    .xAxis(.bottom, label: "X axis label", labelOffset: 10, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_10offset_center_noticks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, showTickLabels: false, label: "X axis label", labelOffset: 10)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_10offset_leading_noticks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, showTickLabels: false, label: "X axis label", labelOffset: 10, labelAlignment: .leading)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testBottomXAxis_10offset_trailing_noticks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, showTickLabels: false, label: "X axis label", labelOffset: 10, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        // MARK: Leading Y Axis tests

        func testLeadingYAxis_0offset_center_noTicks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, showTickLabels: false, label: "Y axis label", labelOffset: 0, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_0offset_top_noTicks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, showTickLabels: false, label: "Y axis label", labelOffset: 0, labelAlignment: .top)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_0offset_bottom_noTicks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, showTickLabels: false, label: "Y axis label", labelOffset: 0, labelAlignment: .bottom)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_0offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, label: "Y axis label", labelOffset: 0, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_0offset_top() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, label: "Y axis label", labelOffset: 0, labelAlignment: .top)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_0offset_bottom() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, label: "Y axis label", labelOffset: 0, labelAlignment: .bottom)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_10offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, label: "Y axis label", labelOffset: 10, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_10offset_top() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, label: "Y axis label", labelOffset: 10, labelAlignment: .top)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLeadingYAxis_10offset_bottom() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, label: "Y axis label", labelOffset: 10, labelAlignment: .bottom)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        // MARK: Top X Axis Tests

        func testTopXAxis_0offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, label: "X axis label", labelOffset: 0, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_0offset_leading() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, label: "X axis label", labelOffset: 0, labelAlignment: .leading)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_0offset_trailing() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, label: "X axis label", labelOffset: 0, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_10offset_center() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, label: "X axis label", labelOffset: 10, labelAlignment: .center)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_10offset_leading() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, label: "X axis label", labelOffset: 10, labelAlignment: .leading)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_10offset_trailing() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, label: "X axis label", labelOffset: 10, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_10offset_center_noticks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, showTickLabels: false, label: "X axis label", labelOffset: 10)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_10offset_leading_noticks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, showTickLabels: false, label: "X axis label", labelOffset: 10, labelAlignment: .leading)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testTopXAxis_10offset_trailing_noticks() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, showTickLabels: false, label: "X axis label", labelOffset: 10, labelAlignment: .trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }
    #endif
}
