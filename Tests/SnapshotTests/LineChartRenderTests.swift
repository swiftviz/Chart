//
//  LineChartRenderTests.swift
//

import Chart
import SnapshotTesting
import SwiftUI
import XCTest

final class LineChartRenderTests: XCTestCase {
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

    let range: ClosedRange<Int> = 0 ... 100

    #if os(macOS)
        func testLineChartImageRendering() throws {
            let chart = Chart {
                LineMark(data: self.data,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
            }
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLineChartXAxisSimpleRendering() throws {
            let middleData = range.map { num in
                SampleData(xValue: Double(num) / 5, yValue: sin(Double(num) / 5))
            }
            let chart = Chart {
                LineMark(data: middleData,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue)).xAxis()
            }
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLineChartYAxisSimpleRendering() throws {
            let middleData = range.map { num in
                SampleData(xValue: Double(num) / 5, yValue: sin(Double(num) / 5))
            }
            let chart = Chart {
                LineMark(data: middleData,
                         x: QuantitativeVisualChannel(\.xValue),
                         y: QuantitativeVisualChannel(\.yValue))
                    .yAxis()
            }
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testLineChartDualAxisSimpleRendering() throws {
            let middleData = range.map { num in
                SampleData(xValue: Double(num) / 5, yValue: sin(Double(num) / 5))
            }
            let chart = Chart {
                LineMark(data: middleData,
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

    #endif
}
