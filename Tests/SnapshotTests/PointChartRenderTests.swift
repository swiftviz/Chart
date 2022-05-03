import Chart
import SnapshotTesting
import SwiftUI
import XCTest

struct SampleData {
    let xValue: Double
    let yValue: Double
}

private let referenceSize = CGSize(width: 300, height: 200)

final class PointChartRenderTests: XCTestCase {
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
}

private extension SwiftUI.View {
    func referenceFrame() -> some View {
        frame(width: referenceSize.width, height: referenceSize.height)
    }
}
