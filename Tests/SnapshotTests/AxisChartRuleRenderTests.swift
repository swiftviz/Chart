//
//  AxisChartRuleRenderTests.swift
//

import Chart
import SnapshotTesting
import SwiftUI
import XCTest

final class AxisChartRuleRenderTests: XCTestCase {
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

    let options: DebugRendering = [] // [.all]
    let resetRecording: Bool = false
    #if os(macOS)

        // MARK: Bottom X Axis Tests

        func testBottomAxisGrid() throws {
            let chart = Chart(_options: options) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.bottom, chartRules: true)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize),
                record: resetRecording
            )
        }

        func testTopAxisGrid() throws {
            let chart = Chart(_options: options) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .xAxis(.top, chartRules: true)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize),
                record: resetRecording
            )
        }

        func testLeadingAxisGrid() throws {
            let chart = Chart(_options: options) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, chartRules: true)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize),
                record: resetRecording
            )
        }

        func testTrailingAxisGrid() throws {
            let chart = Chart(_options: options) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.trailing, chartRules: true)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize),
                record: resetRecording
            )
        }

        func testLeadingBottomAxisGrid() throws {
            let chart = Chart(_options: options) {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis(.leading, chartRules: true)
                    .xAxis(.bottom, chartRules: true)
            }

            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize),
                record: resetRecording
            )
        }

    #endif
}
