import Chart
import SnapshotTesting
import SwiftUI
import XCTest


final class PointChartRenderTests: XCTestCase {
    struct SampleData {
        let xValue: Double
        let yValue: Double
    }
    #if os(macOS)
        func testPointChartImageRendering() throws {
            let chart = Chart {
                PointMark(data: [SampleData(xValue: 2, yValue: 3), SampleData(xValue: 3, yValue: 5)],
                          x: QuantitativeVisualChannel(\.xValue),
                          y: QuantitativeVisualChannel(167))
            }
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }

        func testPointChartImageRenderingSinglePoint() throws {
            let chart = Chart {
                PointMark(data: [SampleData(xValue: 2, yValue: 3)],
                          x: QuantitativeVisualChannel(\.xValue),
                          y: QuantitativeVisualChannel(167))
            }
            assertSnapshot(
                matching: chart.referenceFrame(),
                as: .image(size: referenceSize)
            )
        }
    #endif
}
