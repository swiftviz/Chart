import Chart
import SnapshotTesting
import SwiftUI
import XCTest

struct SampleData {
    let xValue: Double
    let yValue: Double
}

final class PointChartRenderTests: XCTestCase {
    #if os(macOS)
        func testChartImageRendering() throws {
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

        func testChartImageRenderingSinglePoint() throws {
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
