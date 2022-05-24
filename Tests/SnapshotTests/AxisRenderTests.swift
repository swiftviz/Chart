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

    #endif
}
