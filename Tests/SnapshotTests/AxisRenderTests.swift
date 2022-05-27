//
//  AxisRenderTests.swift
//

import Chart
import SnapshotTesting
import SwiftUI
import XCTest

final class AxisRenderTests: XCTestCase {
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
        func testNoAxisChart() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
            }
            .margin(.all, 5)
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisBottom() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue)).xAxis()
            }
            .margin(.all, 5)
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testYAxisLeading() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis()
            }
            .margin(.all, 5)
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisBottomYAxisLeading() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis()
                    .yAxis()
            }
            .margin(.all, 5)

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisBottomYAxisTrailing() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis()
                    .yAxis(.trailing)
            }.margin(.all, 5)

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisTopYAxisTrailing() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top)
                    .yAxis(.trailing)
            }.margin(.all, 5)

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisTopYAxisLeading() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top)
                    .yAxis()
            }.margin(.all, 5)

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisBottomInset() throws {
            let chart = Chart(margin: 5, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue)).xAxis()
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testYAxisLeadingInset() throws {
            let chart = Chart(margin: 5, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis()
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisBottomYAxisLeadingInset() throws {
            let chart = Chart(margin: 5, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis()
                    .yAxis()
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisBottomYAxisTrailingInset() throws {
            let chart = Chart(margin: 5, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis()
                    .yAxis(.trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisTopYAxisTrailingInset() throws {
            let chart = Chart(margin: 5, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top)
                    .yAxis(.trailing)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testXAxisTopYAxisLeadingInset() throws {
            let chart = Chart(margin: 5, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top)
                    .yAxis()
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testAxisOptionsDefault() throws {
            let chart = Chart(margin: 10, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis()
                    .yAxis()
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testAxisOptionsNoRule() throws {
            let chart = Chart(margin: 10, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(rule: false)
                    .yAxis(rule: false)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testAxisOptionsInner() throws {
            let chart = Chart(_options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(tickOrientation: .inner)
                    .yAxis(tickOrientation: .inner)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testAxisOptionsTickLength() throws {
            let chart = Chart(margin: 10, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(tickLength: 10)
                    .yAxis(tickLength: 15)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testAxisOptionsTickPadding() throws {
            let chart = Chart(margin: 10, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(tickPadding: 10)
                    .yAxis(tickPadding: 15)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testAxisOptionsTickLengthAndPadding() throws {
            let chart = Chart(margin: 10, inset: 10, _options: [.all]) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(tickLength: 10, tickPadding: 10)
                    .yAxis(tickLength: 10, tickPadding: 15)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

    #endif
}
