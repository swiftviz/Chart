//
//  BarChartRenderTests.swift
//

import Chart
import SnapshotTesting
import SwiftUI
import XCTest

final class BarChartRenderTests: XCTestCase {
    struct SampleData {
        let name: String
        let value: Double
    }

    let data: [SampleData] = [
        SampleData(name: "A", value: 3),
        SampleData(name: "B", value: 5),
        SampleData(name: "C", value: 2),
        SampleData(name: "D", value: 7),
    ]
    #if os(macOS)
        func testVerticalBarChartImageRendering() throws {
            let chart = Chart {
                BarMark(data: self.data,
                        value: QuantitativeVisualChannel(\.value),
                        category: BandVisualChannel(\.name))
            }.border(.blue)
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testHorizontalBarChartImageRendering() throws {
            let chart = Chart {
                BarMark(orientation: .horizontal,
                        data: self.data,
                        value: QuantitativeVisualChannel(\.value),
                        category: BandVisualChannel(\.name))
            }.border(.blue)
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }
    #endif
}
